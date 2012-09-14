class UsersController < Devise::RegistrationsController
  
  before_filter :setup_jobs, :only => [:new, :create, :edit, :update]
  before_filter :authenticate_user!, only: [:index, :edit, :update, :delete, :add_tags]
  before_filter :beta, only: [:new, :create]
  
  def index
    unless Rails.env != "production" || current_user
      redirect_to :root, :notice => "Sorry, we're not ready yet. Please sign up to our mailing list to be notified. Thanks!" and return
    end
    
    unless params[:sort] && params[:sort] != "location"
      if current_user && current_user.coords && current_user.coords != [199.9, 199.9]
        @coords = current_user.coords
      else
        remote_ip = request.remote_ip
        remote_ip = "24.6.151.215" if remote_ip == "127.0.0.1"
        coords = Geoip.lookup(remote_ip)
        @coords = [coords[:latitude], coords[:longitude]] if coords[:latitude].present? && coords[:longitude].present?
      end
    end

    if @coords
      max_distance = params[:max_distance].try(:to_i) || 50
      @users = Location.nearby_users(@coords, max_distance).page(params[:page])
      @users = nil if @users.count == 0
    end
    @users ||= User.order("id DESC").page(params[:page])
  end
  
  def new
    if Rails.env == "production"
      flash[:notice] = "Sorry, we're still in closed beta"
      redirect_to root_path and return
    end
    super
  end
  
  def edit
    user_games = resource.games || []
    @games = (["Rock Band", "Smash Bros", "Tekken", "Street Fighter", "Starcraft", "Armored Core", "IIDX", "DDR"] + user_games).compact.uniq
    super
  end
  
  def update_profile
    fields = [:name, :job_id, :location]
    stats = [:strength, :agility, :vitality, :mind]
    fields += stats if current_user.free_skill_points > 0 || stats.all?{|s| current_user.send(s) == 1}
    Rails.logger.debug "fields: #{fields.inspect}"
    profile = params[:user].slice(*fields)
    
    if current_user.update_attributes(profile)
      flash[:notice] = "Profile updated!"
    else
      flash[:error] = "Couldn't update your profile: #{current_user.errors.full_messages.join("<br />").html_safe}"
    end
    
    current_user.graffitis.destroy_all
    games = params[:games].keys
    games << params[:new_games]
    games.each do |game|
      next if game == ''
      tag = Tag.where(name: game).first_or_create
      graffiti = Graffiti.where(user_id: current_user.id, tag_id: tag.id, kind: "games").first_or_create
    end
    
    redirect_to edit_user_registration_path(current_user)
  end
  
  def show
    @user = User.find_by_id(params[:id])
    redirect_to root_path, error: "Sorry, couldn't find that user." and return unless @user.present?
    @common = @user.games & current_user.games if current_user.present?
  end
  
  def add_tags
    tags = params.slice(:genres, :scenes, :games)
    tags.each do |relevance, key|
      tag = Tag.where(name: key).first_or_create
      graffiti = Graffiti.where(user_id: current_user.id, tag_id: tag.id, kind: "games").first_or_create
    end
    render :json => {:relevance => tags.keys.first, :tag => tags.values.first}
  end
  
  def get_location
    result = Geoip.lookup(request.remote_ip)
    response = result.present? ? {:location => "#{result[:city]}, #{result[:country_code]}"} : {}
    render :json => response
  end
  
  private
    def setup_jobs
      @jobs = Job.all
    end
end
