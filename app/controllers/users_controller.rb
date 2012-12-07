class UsersController < Devise::RegistrationsController
  before_filter :section_name
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update]
  before_filter :authenticate_user!, only: [:index, :edit, :update, :delete, :add_tags]
  
  def index
    if params[:tab] == "nearby"
      @tab = "nearby"
      @coords = current_user.coords if current_user.present?
      @coords ||= Geoip.lookup(request.remote_ip)
      if @coords.present?
        @users = User.nearby(@coords)
        @users -= [current_user] if current_user.present?
        @users = @users.paginate(page: params[:page])
      else
        flash.now[:alert] = "Sorry, we couldn't find your location."
        @users = [].paginate(page: 1)
      end
    elsif params[:network].present?
      @tab = "network"
      @network = params[:network]
      if @network == "other"
        @network = "Other Networks"
        @users = Nickname.where("network NOT IN (?)", Nickname.networks).includes(:user).order("created_at desc").page(params[:page]) if params[:network].present?
      else
        @users = Nickname.where(network: params[:network]).includes(:user).order("created_at desc").page(params[:page]) if params[:network].present?
      end
    else
      @tab = "cool"
      @users ||= (current_user.coplayers - [current_user]).paginate(page: params[:page]) if current_user.present?
      @users = User.order("id desc").page(params[:page]) unless @users.present?
    end
  end
  
  def edit
    user_games = resource.games || []
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR"] + user_games).compact.uniq
    @nicknames = resource.nicknames + [Nickname.new(user_id: current_user.id)]
    super
  end
  
  def update_profile
    fields = [:name, :job_id]
    stats = [:strength, :agility, :vitality, :mind]
    fields += stats if current_user.free_skill_points > 0 || stats.all?{|s| current_user.send(s) == 1}
    profile = params[:user].slice(*fields)
    
    if current_user.update_attributes(profile)
      flash[:notice] = "Profile updated!"
    else
      flash[:error] = "Couldn't update your profile: #{current_user.all_errors}"
    end
    
    games = params[:games].present? ? params[:games].keys : []
    games << params[:new_games]
    current_user.games = games
    current_user.place = params[:user][:place]
    
    current_user.nicknames.destroy_all
    nicknames = params[:nicknames]
    nicknames = [] unless nicknames.present?
    nicknames.each do |nickname|
      network = nickname["network"] == "other" ? nickname["network_other"] : nickname["network"]
      next unless nickname["name"].present? && network.present?
      n = Nickname.where(user_id: current_user.id, network: network).first_or_initialize
      n.name = nickname["name"]
      n.save
    end
    
    redirect_to edit_user_registration_path
  end
  
  def show
    @user = User.find_by_id(params[:id])
    redirect_to root_path, error: "Sorry, couldn't find that user." and return unless @user.present?
    @common = @user.game_groups & current_user.game_groups if current_user.present? && @user != current_user
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
      @users = User.where("id != ?", current_user.id).order("id desc").limit(10).all unless @users.present?
      @groups = current_user.groups
      
      @coords = current_user.location.coords if current_user.location
      @coords ||= Geoip.lookup(request.remote_ip)
      
      @nearby_users = current_user.nearby_users.to_a if current_user.location
      @nearby_users ||= User.nearby(@coords).to_a
      @nearby_users -= (@users + [current_user])
      
      @nearby_groups = current_user.nearby_groups.to_a if current_user.location
      @nearby_groups ||= Group.nearby(@coords).to_a
      @nearby_groups -= @groups
    else
      @coords = Geoip.lookup(request.remote_ip)
      @nearby_users = User.nearby(@coords)
      @nearby_groups = Group.nearby(@coords)
      @users = User.order("id desc").limit(10).all
      @groups = Group.order("updated_at desc").limit(10).all
    end
  end
  
  def notifications
    @notifications = current_user.notifications
  end
  
  private
    def setup_jobs
      @jobs = Job.for_user(current_user) if current_user.present?
      @jobs ||= Job.new_jobs
    end
    
    def after_sign_up_path_for(resource)
      edit_user_registration_path
    end
    
    def after_update_path_for(resource)
      edit_user_registration_path(:tab => "settings")
    end
    
    def section_name
      "Account"
    end
end
