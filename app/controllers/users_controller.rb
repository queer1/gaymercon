class UsersController < Devise::RegistrationsController
  before_filter :section_name
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update, :join]
  before_filter :authenticate_user!, except: [:index, :show, :join, :joined]
  
  layout :layout_selector
  
  include DeviseRedirector
  
  def index
    @tab = params[:tab] if params[:tab].present?
    @tab ||= "network" if params[:network].present?
    @tab ||= "superscope" if current_user.present?
    @tab ||= "cool"
    
    if ["following", "followers", "superscope"].include?(@tab) && current_user.nil?
      session[:return_to] = users_path(tab: @tab)
      redirect_to login_path, alert: "You must sign in to see that" and return
    end
    
    case @tab
    when "superscope"
      if current_user.game_groups.count == 0
        flash.now[:alert] = "You need to add some games to your profile to use SuperScope! <a href='#{edit_user_registration_path(tab: 'games')}'>Do that here</a>".html_safe
      elsif current_user.network_names.count == 0
        flash.now[:alert] = "You need to add some gamertags to your profile to use SuperScope! <a href='#{edit_user_registration_path(tab: 'nicknames')}'>Do that here</a>".html_safe
      end
      group_ids = current_user.game_groups.collect(&:id)
      
      network_names = current_user.nicknames.collect(&:network)
      network_users = Nickname.where(network: network_names).collect(&:user_id) - [current_user.id]
      
      @users = [].paginate(page: params[:page]) unless group_ids.present? && network_users.present?
      @users ||= User.where(id: network_users).joins("left join (SELECT memberships.user_id, count(*) as common_count FROM `memberships` WHERE `memberships`.`group_id` IN (#{group_ids.join(', ')}) GROUP BY user_id ORDER BY common_count) as m on users.id = m.user_id").order("common_count desc").page(params[:page])
      
    when "nearby"
      @section_name = "Nearby People"
      @coords = current_user.coords if current_user.present?
      @coords ||= Geoip.lookup(request.remote_ip)
      if @coords.present?
        @users = User.nearby(@coords)
        @users -= [current_user] if current_user.present?
        # arrays have to use #paginate, only relations can use #page
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
    when "followers"
      @section_name = "Followers"
      @users = current_user.followers.page(params[:page])
    else
      @section_name = "Cool People"
      @users ||= (current_user.coplayers - [current_user]).paginate(page: params[:page]) if current_user.present?
      @users = User.order("id desc").page(params[:page]) unless @users.present?
    end
  end
  
  def map
    if request.xhr?
      @users = User.nearby([params[:lat].to_f, params[:lng].to_f]).all
      ret = {}
      @users.collect do |user|
        games = []
        common_games = []
        networks = []
        common_networks = []
        if current_user.present?
          common_games += user.game_groups & current_user.game_groups
          games += user.game_groups.take(4) unless common_games.present?
          common_networks += user.network_names & current_user.network_names
          networks += user.network_names unless common_networks.present?
        else
          games += user.game_groups.take(4)
          networks += user.network_names
        end
        
        user_json = { lat: user.coords.first, lng: user.coords.last, title: user.name,
          link: user_path(user), avatar: user.avatar, username: user.name, user_class: user.job.try(:name), level: user.level,
          common_games: common_games.collect{|g| {name: g.name, link: group_path(g) } },
          games: games.collect{|g| {name: g.name, link: group_path(g) } },
          common_networks: common_networks.collect{|n| n.humanize },
          networks: networks.collect{|n| n.humanize }
        }
        key = "#{user.coords.first}:#{user.coords.last}"
        ret[key] ||= []
        ret[key] << user_json
      end
      Rails.logger.debug ret.to_json
      render :json => ret
    end
  end
  
  def create
    session[:user_return_to] ||= join_path
    super
  end
  
  def edit
    user_games = resource.games || []
    
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR", 'Magic The Gathering', 'Persona 4', 'Phoenix Wright', 'Mass Effect', 'Dungeons & Dragons', 'Dark Souls', 'Settlers of Catan', 'Madden', 'Halo', 'Team Fortress 2', 'Dragon Age'] + user_games).compact.uniq
    @nicknames = resource.nicknames + [Nickname.new(user_id: current_user.id)]
    super
  end
  
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.where(id: current_user.id).first
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      flash.now[:alert] = @user.all_errors
      render "edit"
    end
  end
  
  def update_profile
    fields = [:name, :job_id, :username, :about, :header]
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
    @user = User.find_by_url(params[:id])
    redirect_to root_path, error: "Sorry, couldn't find that user." and return unless @user.present?
    Notification::FollowNotification.clear(@user, current_user) if current_user.present?
    @header_img = @user.header.url(:large) if @user.header.present?
    @section_name = @user.name
    @common = @user.game_groups & current_user.game_groups if current_user.present? && @user != current_user
    
    posts = @user.posts.order("updated_at desc").limit(10)
    comments = @user.comments.order("updated_at desc").limit(10)
    @discussions = []
    posts.each{|p| @discussions << {title: p.title, link: group_post_path(p.group, p), time: p.updated_at} unless @discussions.count{|d| d[:link] == group_post_path(p.group, p)} > 0 || p.group.private? }
    comments.each{|c| @discussions << {title: c.group_post.title, link: group_post_path(c.group, c.group_post), time: c.updated_at} unless @discussions.count{|d| d[:link] == group_post_path(c.group, c.group_post)} > 0 || c.group.private? }
    @discussions = @discussions.uniq.sort_by{|d| d[:time] }.reverse.take(10)
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
    user = User.find_by_url(params[:id])
    redirect_to :back, alert: "Sorry, couldn't find that user" and return unless user.present?
    begin
      current_user.followed_users << user
      flash[:notice] = "You are now following #{user.name}"
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = e.message
    end
    redirect_to :back
  end
  
  def unfollow
    user = User.find_by_url(params[:id])
    redirect_to :back, alert: "Sorry, couldn't find that user" and return unless user.present?
    current_user.followed_users.delete(user)
    redirect_to :back, notice: "You are no longer following #{user.name}"
  end
  
  def notifications
    if current_user.nil? || !current_user.present?
      session[:return_to] = notifications_path
      redirect_to login_path, alert: "You must be logged in to check your notifications"
    end
    
    if request.post? && params[:mark_all]
      Notification.where(user_id: current_user.id, read: false).update_all(read: true)
    end
    # no idea how nils are making it past the nil check above, but they are
    @notifications = current_user.nil? ? [].paginate(page: params[:page]) : current_user.notifications.paginate(page: params[:page])
  end
  
  def join
    session.delete(:badge_code) if params[:clear].present?
    badge_code = params[:badge_code] || session[:badge_code] || params[:badge].try(:[], 'code')
    if badge_code && @badge = Badge.where(code: badge_code).first
      session[:badge_code] = badge_code
      if @badge.user_id.present? && (current_user.nil? || @badge.user_id != current_user.id)
        flash.now[:alert] = "Ruh roh! Somebody alredy registered that badge! If that was supposed to be you, please <a href='mailto:badges@gaymerconnect.com'>contact the admins</a>".html_safe
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
      @job = current_user.job
      @job ||= @jobs.sample
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
      flash.now[:alert] = "Ruh roh! Somebody else registered that badge! If that was supposed to be you, please <a href='mailto:badges@gaymerconnect.com'>contact the admins</a>".html_safe
      @badge = nil
    end
    @groups = current_user.groups.with_posts.where(kind: "game").order("last_post_date desc").limit(5)
    render :layout => "no_controls"
  end
  
  def find_by_name
    @user = User.where(name: params[:name]).first
    render :json => @user
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
