class UsersController < Devise::RegistrationsController
  before_filter :section_name
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update, :join]
  before_filter :authenticate_user!, except: [:index, :show, :connect, :join, :joined]
  
  layout :layout_selector
  
  include DeviseRedirector
  
  def index
    @tab = params[:tab] if params[:tab].present?
    @tab ||= "network" if params[:network].present?
    @tab ||= "following" if current_user.present?
    @tab ||= "cool"
    
    case @tab
    when "nearby"
      @section_name = "Nearby People"
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
    when "network"
      @network = params[:network]
      @section_name = @network.capitalize
      if @network == "other"
        @users = User.other_networks.page(params[:page])
      else
        @users = User.network(@network).page(params[:page])
      end
    when "following"
      @section_name = "Following"
      @users = current_user.followed_users.page(params[:page])
    else
      @section_name = "Cool People"
      @users ||= (current_user.coplayers - [current_user]).paginate(page: params[:page]) if current_user.present?
      @users = User.order("id desc").page(params[:page]) unless @users.present?
    end
  end
  
  def create
    session[:user_return_to] ||= join_path
    super
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
    current_user.place = params[:user][:place]
    
    redirect_to edit_user_registration_path
  end
  
  def update_games
    games = params[:games].present? ? params[:games].keys : []
    games << params[:new_games]
    current_user.games = games
    flash[:notice] = "Games updated!"
    redirect_to edit_user_registration_path(tab: "games")
  end
  
  def update_nicknames
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
    flash[:notice] = "Gamer Tags updated!"
    redirect_to edit_user_registration_path(tab: "nicknames")
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
  
  def follow
    user = User.find_by_id(params[:id])
    redirect_to :back, alert: "Sorry, couldn't find that user" and return unless user.present?
    current_user.followed_users << user
    redirect_to :back, notice: "You are now following #{user.name}"
  end
  
  def unfollow
    user = User.find_by_id(params[:id])
    redirect_to :back, alert: "Sorry, couldn't find that user" and return unless user.present?
    current_user.followed_users.delete(user)
    redirect_to :back, notice: "You are no longer following #{user.name}"
  end
  
  def notifications
    @notifications = current_user.notifications
  end
  
  def join
    session.delete(:badge_code) if params[:clear].present?
    badge_code = params[:badge_code] || session[:badge_code] || params[:badge].try(:[], 'code')
    if badge_code && @badge = Badge.where(code: badge_code).first
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
    elsif badge_code
      flash.now[:alert] = "Ruh roh! Couldn't find a badge for that badge code."
    end
    
    @badge ||= current_user.badge if current_user.present?
    @section_name = @badge.present? ? "Get Your Badge" : "Create a Profile"
    @section_subhead = "Find friends of every<br />identity who play the<br />same games you do."
    
    if current_user.present? && request.post?
      if params[:user].present?
        fields = [:name, :job_id, :about]
        profile = params[:user].slice(*fields)
        fields.each {|f| current_user.send("#{f}=", params[:user][f]) }
        unless current_user.save
          flash.now[:alert] = "Oops, there was a problem: #{current_user.all_errors}"
          render :layout => "empty" and return
        end
      
        games = params[:games].present? ? params[:games].keys : []
        games << params[:new_games]
        current_user.games = games
      
        redirect_to joined_path, notice: "Profile updated!" and return
      end
      
      fields = [:first_name, :last_name, :age, :address_1, :address_2, :city, :province, :country, :postal]
      parms = params[:badge].slice(*fields)
      parms[:user_id] = current_user.id
      @badge.update_attributes(parms)
      if @badge.valid? && @badge.filled_out?
        session.delete(:badge_code)
        flash.now[:notice] = "Badge info saved!"
      else
        errors = @badge.all_errors
        fields.delete(:address_2)
        fields.each {|f| errors << "#{f.to_s.humanize} cannot be blank<br />" unless @badge.send(f).present? }
        flash.now[:alert] = "There was a problem: #{errors}".html_safe
      end
    end
    
    if current_user.present?
      @user = current_user
      @jobs = Job.for_user(current_user)
      @job = current_user.job || @jobs.sample
      @user.job = @job
      @games = current_user.games || []
    end
    
    @header_img = "gaymers.png"
    
    render :layout => 'no_controls'
  end
  
  def joined
    redirect_to join_path, alert: "Please log in" and return unless current_user.present?
    session.delete(:badge_code)
    @badge = current_user.badge
    if @badge.present? && @badge.user_id.present? && (current_user.nil? || @badge.user_id != current_user.id)
      flash.now[:alert] = "Ruh roh! Somebody else registered that badge! If that was supposed to be you, please <a href='mailto:badges@gaymercon.org'>contact the admins</a>".html_safe
      @badge = nil
    end
    @groups = current_user.groups.with_posts.where(kind: "game").order("last_post_date desc").limit(5)
    render :layout => "no_controls"
  end
  
  private
    def setup_jobs
      @jobs = Job.for_user(current_user) if current_user.present?
      @jobs ||= Job.new_jobs
    end
    
    def after_update_path_for(resource)
      edit_user_registration_path(:tab => "settings")
    end
    
    def section_name
      @section_name = @user.name if @user.present?
      @section_name ||= current_user.name if current_user.present?
      @section_name ||= "Account"
    end
    
    def layout_selector
      params[:action] == "new" ? "no_controls" : "application"
    end
end
