class PanelsController < ApplicationController
  
  before_filter :setup_panel, except: [:index, :new, :create]
  before_filter :authenticate_panel, only: [:edit, :update, :destroy]
  
  def index
    @popular = Panel.order("score desc")
    @new = Panel.where("id NOT IN (?)", @popular.collect(&:id)).order("created_at desc")
    displayed_ids = @popular.collect(&:id) + @new.collect(&:id)
    @all = Panel.where("id NOT IN (?)", displayed_ids).order("updated_at desc").page(params[:page])
  end
  
  def show
  end
  
  def new
    @panel = Panel.new
    @panelists = [Panelist.new]
  end
  
  def create
    kind = params[:panel][:kind] == "Other" ? params[:kind_other] : params[:panel][:kind]
    @panel = Panel.create(user: current_user, title: params[:panel]["title"], kind: kind, description: params[:panel]["description"])
    if @panel.persisted?
      @panelists = params[:panel][:panelists].collect {|p| Panelist.create(p.merge(panel_id: @panel.id)) }
      redirect_to edit_panel_path(@panel), notice: "Panel successfully created!"
    else
      @panelists = params[:panel][:panelists].collect {|p| Panelist.new(p) }
      flash.now[:error] = "There was a problem with your panel: #{@panel.all_errors}"
      render :new
    end
  end
  
  def edit
    @panelists = @panel.panelists + [Panelist.new]
  end
  
  def update
    kind = params[:panel][:kind] == "Other" ? params[:kind_other] : params[:panel][:kind]
    @panel.update_attributes(title: params[:panel]["title"], kind: kind, description: params[:panel]["description"])
    @panel.panelists.destroy_all
    @panelists = params[:panel][:panelists].collect {|p| Panelist.create(p.merge(panel_id: @panel.id)) }
    if @panel.persisted?
      redirect_to edit_panel_path(@panel), notice: "Panel successfully updated!"
    else
      flash.now[:error] = "There was a problem with your panel: #{@panel.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @panel.destroy
    redirect_to panels_path, notice: "Your panel has been deleted!"
  end
  
  def upvote
    @vote = PanelVote.where(user_id: current_user.id, panel_id: @panel.id).first_or_create
    @vote.value = 1
    @vote.save
    if @vote.persisted?
      render :json => {:success => "Voted!"}
    else
      render :json => {:error => @vote.errors.full_messages}
    end
  end
  
  def downvote
    @vote = PanelVote.where(user_id: current_user.id, panel_id: @panel.id).first_or_create
    @vote.value = -1
    @vote.save
    if @vote.persisted?
      render :json => {:success => "Voted!"}
    else
      render :json => {:error => @vote.errors.full_messages}
    end
  end
  
  private
  
    def setup_panel
      @panel = Panel.find_by_id(params[:id])
      @panel ||= Panel.find_by_id(params[:panel_id])
      redirect_to panels_path, alert: "Sorry, couldn't find that panel" unless @panel
    end
    
    def authenticate_panel
      unless current_user.present? && (@panel.user == current_user || current_user.admin?)
        redirect_to panels_path, error: "You don't have permission to do that." and return false
      end
    end
end
