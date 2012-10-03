class UsersController < Devise::RegistrationsController
  
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update]
  before_filter :authenticate_user!, only: [:index, :edit, :update, :delete, :add_tags]
  before_filter :beta, only: [:new, :create]
  
  def index
    @coords = current_user.coords if current_user.present?
    @coords ||= Geoip.lookup(request.remote_ip)
    @nearby_users = User.nearby(@coords)
    @nearby_users -= [current_user] if current_user.present?
    
    @users = current_user.coplayers if current_user
    @users -= [current_user] if current_user.present?
    @users = User.order("id desc").page(params[:page]) unless @users.present?
  end
  
  def edit
    user_games = resource.games || []
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR"] + user_games).compact.uniq
    super
  end
  
  def update_profile
    fields = [:name, :job_id]
    stats = [:strength, :agility, :vitality, :mind]
    fields += stats if current_user.free_skill_points > 0 || stats.all?{|s| current_user.send(s) == 1}
    Rails.logger.debug "fields: #{fields.inspect}"
    profile = params[:user].slice(*fields)
    
    if current_user.update_attributes(profile)
      flash[:notice] = "Profile updated!"
    else
      flash[:error] = "Couldn't update your profile: #{current_user.all_errors}"
    end
    
    current_user.graffitis.destroy_all
    games = params[:games].present? ? params[:games].keys : []
    games << params[:new_games]
    current_user.games = games
    current_user.place = params[:user][:place]
    
    redirect_to edit_user_registration_path(current_user)
  end
  
  def show
    @user = User.find_by_id(params[:id])
    redirect_to root_path, error: "Sorry, couldn't find that user." and return unless @user.present?
    @common = @user.games & current_user.games if current_user.present? && @user != current_user
  end
  
  def add_tags
    if params[:games].is_a?(String)
      current_user.add_game(params[:games])
      render :json => {:relevance => 'games', :tag => params[:games]}
    elsif params[:games].is_a?(Hash)
      current_user.add_games(params[:games])
      render :json => {:relevance => 'games', :tag => params[:games].values.first}
    end
  end
  
  def connect
    if current_user.present?
      @users = current_user.coplayers
      @users = @users = User.where("id != ?", current_user.id).order("id desc").limit(10).all unless @users.present?
      @groups = current_user.groups
      
      @coords = current_user.location.coords if current_user.location
      @coords ||= Geoip.lookup(request.remote_ip)
      
      @nearby_users = current_user.nearby_users.all if current_user.location
      @nearby_users ||= User.nearby(@coords).all
      @nearby_users -= (@users + [current_user])
      
      @nearby_groups = current_user.nearby_groups.all if current_user.location
      @nearby_groups ||= Group.nearby(@coords).all
      @nearby_groups -= @groups
    else
      @coords = Geoip.lookup(request.remote_ip)
      @nearby_users = User.nearby(@coords)
      @nearby_groups = Group.nearby(@coords)
      @users = User.order("id desc").limit(10).all
      @groups = Group.order("updated_at desc").limit(10).all
    end
  end
  
  private
    def setup_jobs
      @jobs = Job.all
    end
    
    def after_sign_up_path_for(resource)
      edit_user_registration_path
    end
    
    def after_update_path_for(resource)
      edit_user_registration_path(:tab => "settings")
    end
end
