class GroupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_group, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_owner, only: [:edit, :update, :destroy]
  
  def index
    @groups = Group.order("updated_at desc").page(params[:page])
  end
  
  def show
    if @group.kind == "location"
      @nearby_users = @group.nearby_users
      @nearby_users = @nearby_users.where("id != ?", current_user.id) if current_user
      @nearby_users = @nearby_users.to_a.shuffle.take(10)
    end
  end
  
  def new
    @group = Group.new
  end
  
  def create
    parms = params[:group].slice(:name, :type, :description, :kind, :header, :site_name, :site_link)
    parms[:moderator_id] = current_user.id
    @group = Group.create(parms)
    if @group.valid?
      @group.place = params[:group][:place]
      redirect_to edit_group_path(@group), notice: "Group created!"
    else
      flash.now[:alert] = "Sorry, there was a problem: #{@group.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:group].slice(:name, :type, :description, :kind, :header, :site_name, :site_link)
    @group.update_attributes(parms)
    if @group.valid?
      @group.place = params[:group][:place]
      redirect_to edit_group_path(@group), notice: "Group updated!"
    else
      flash.now[:alert] = "Sorry, there was a problem: #{@group.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @group.destroy
    redirect_to groups_path, notice: "Group deleted."
  end
  
  private
    def find_group
      @group = Group.find_by_id(params[:id])
      redirect_to groups_path, alert: "Sorry, couldn't find that group" unless @group.present?
    end
    
    def authenticate_owner
      redirect_to groups_path, alert: "Sorry, you don't have permission to do that." unless @group.moderator_id == current_user.id
    end
end
