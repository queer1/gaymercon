class UsersController < Devise::RegistrationsController
  before_filter :section_name
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update, :join]
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
    fields = [:name, :job_id, :username, :about]
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
  
  def join
    badge_code = params[:badge_code] || session[:badge_code] || params[:badge].try(:[], 'code')
    if badge_code
      @badge = Badge.where(code: badge_code).first
      session[:badge_code] = badge_code
      if @badge.user_id.present? && (current_user.nil? || @badge.user_id != current_user.id)
        flash.now[:alert] = "Ruh roh! Somebody alredy registered that badge! If that was supposed to be you, please <a href='mailto:badges@gaymercon.org'>contact the admins</a>".html_safe
        @badge = nil
        session.delete(:badge_code)
      elsif current_user.present? && current_user.badge.present? && @badge.id != current_user.badge.id
        flash.now[:alert] = "Sorry, you can only have one badge per account"
        @badge = current_user.badge
        session.delete(:badge_code)
      end
    end
    
    @badge ||= current_user.badge if current_user.present?
    
    if current_user.present? && request.post?
      fields = [:name, :job_id, :username, :about]
      profile = params[:user].slice(*fields)
      
      games = params[:games].present? ? params[:games].keys : []
      games << params[:new_games]
      current_user.games = games
      
      redirect_to joined_path, notice: "Profile updated!" and return unless @badges.present? && params[:badge].present?
      
      parms = params[:badge].slice(:first_name, :last_name, :age, :address_1, :address_2, :city, :province, :country, :postal)
      parms[:user_id] = current_user.id
      @badge.update_attributes(parms)
      if @badge.valid?
        redirect_to joined_path, notice: "Badge and profile updated!"
      else
        flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      end
    end
    
    if current_user.present?
      user_games = current_user.games || []
    else
      user_games = []
    end
    
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR"] + user_games).compact.uniq
    
    render :layout => 'empty'
  end
  
  def joined
    redirect_to join_path, alert: "Please log in" and return unless current_user.present?
    badge_code = session.delete(:badge_code)
    @badge = current_user.badge
    if @badge.present? && @badge.user_id.present? && (current_user.nil? || @badge.user_id != current_user.id)
      flash.now[:alert] = "Ruh roh! Somebody else registered that badge! If that was supposed to be you, please <a href='mailto:badges@gaymercon.org'>contact the admins</a>".html_safe
      @badge = nil
    end
    @groups = current_user.groups.with_posts.where(kind: "game").order("last_post_date desc").limit(5)
    render :layout => "empty"
  end
  
  private
    def setup_jobs
      @jobs = Job.for_user(current_user) if current_user.present?
      @jobs ||= Job.new_jobs
    end
    
    def after_sign_up_path_for(resource)
      return_to = session.delete(:return_to)
      return return_to if return_to.present?
      edit_user_registration_path
    end
    
    def after_update_path_for(resource)
      edit_user_registration_path(:tab => "settings")
    end
    
    def section_name
      @section_name = @user.name if @user.present?
      @section_name ||= current_user.name if current_user.present?
      @section_name ||= "Account"
    end
end
