class Admin::PanelsController < AdminController
  before_filter :find_panel, except: [:index, :new, :create]
  
  def index
    @panels = Panel.select("panels.*, count(*) as votes").joins("JOIN panel_votes ON panel_votes.panel_id = panels.id").group("panels.id").order("votes DESC").page(params[:page])
  end
  
  def show
  end
  
  def new
    @panel = Panel.new
    @panelists = [Panelist.new]
    render 'panels/new'
  end
  
  def create
    @panel = Panel.write_attributes(params[:panel])
    if @panel.save
      redirect_to admin_edit_panel_path(@panel), notice: "Panel saved!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@panel.all_errors}"
      render :new
    end
  end
  
  def edit
    @panelists = @panel.panelists + [Panelist.new]
    render 'panels/edit'
  end
  
  def update
    if @panel.update_attributes(params[:panel])
      redirect_to admin_edit_panel_path(@panel), notice: "Panel updated"
    else
      flash.now[:alert] = "Oops, sorry, there was a problem: #{@panel.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @panel.destroy
    redirect_to admin_panels_path, notice: "Panel deleted"
  end
  
  private
    def find_panel
      @panel = Panel.find_by_id(params[:id])
      redirect_to admin_panels_path, alert: "Couldn't find that panel" unless @panel.present?
    end
end
