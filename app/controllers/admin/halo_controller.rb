class Admin::HaloController < AdminController
  
  def index
    
  end
  
  def registrations
    @gaymers = Gaymer.order("created_at DESC").paginate(:page => params[:page])
  end
  
  def users
    if(params[:q])
      @users = User.where("name LIKE ? or email LIKE ? or id = ?", "%#{params[:q]}%", "%#{params[:q]}%", params[:q]).order("created_at desc").paginate(page: params[:page])
    end
    @users ||= User.order("created_at desc").paginate(page: params[:page])
    @user = User.new
  end
  
  def edit_user
    @user = User.find_by_id(params[:id])
    redirect_to halo_path("users", alert: "Couldn't find that user") unless @user.present?
    if params[:user]
      @user.update_attributes(params[:user])
      flash[:notice] = "User saved!" if @user.persisted?
      flash[:alert] = "Couldn't update that user - #{@user.errors.full_messages.join('<br />')}" if !@user.persisted?
    end
    @form_path = halo_path("edit_user", @user.id)
    @jobs = Job.all
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR"] + @user.games).compact.uniq
    render 'users/edit'
  end
  
  def add_user
    profile = params[:user]
    profile[:job_id] ||= Job.first.id
    @user = User.create(profile)
    if @user.persisted?
      redirect_to halo_path("users"), notice: "User created!"
    else
      flash[:error] = "There was a problem: #{@user.errors.full_messages.join("<br />")}" 
      redirect_to halo_path("users")
    end
  end
  
  def role
    @user = User.find_by_id(params[:id])
    redirect_to halo_path("users", alert: "Couldn't find that user") unless @user.present?
    @user.role = params[:role]
    if @user.save
      redirect_to halo_path("users"), notice: "User role changed for user ##{@user.id}"
    else
      redirect_to halo_path("users"), alert: "There was a problem updating that user"
    end
  end
  
  def award_xp
    @user = User.find_by_id(params[:id])
    redirect_to halo_path("users", alert: "Couldn't find that user") unless @user.present?
    @user.xp += params[:xp].to_i
    if @user.save
      @user.alerts.create(message: "#{current_user.name} awarded you #{params[:xp]} XP! w00t!")
      flash[:notice] = "#{params[:xp]} awarded to #{@user.name}"
    else
      flash[:alert] = "Sorry, there was a problem. #{@user.errors.full_messages.join('<br />')}"
    end
    redirect_to halo_path("users")
  end
  
  def confirm_panel
    @panel = Panel.find_by_id(params[:id])
    redirect_to panels_path(alert: "Couldn't find that panel") unless @panel.present?
    @panel.update_attributes(confirmed: true)
    if @panel.persisted?
      redirect_to panel_path(@panel, notice: "Panel confirmed!")
    else
      redirect_to panel_path(@panel, alert: "There was a problem: #{@panel.errors.full_messages.join('<br />')}")
    end
  end
  
  def deconfirm_panel
    @panel = Panel.find_by_id(params[:id])
    redirect_to panels_path(alert: "Couldn't find that panel") unless @panel.present?
    @panel.update_attributes(confirmed: false)
    if @panel.persisted?
      redirect_to panel_path(@panel, notice: "Panel deconfirmed!")
    else
      redirect_to panel_path(@panel, alert: "There was a problem: #{@panel.errors.full_messages.join('<br />')}")
    end
  end
  
  def layout
    render "layout", layout: false
  end
end
