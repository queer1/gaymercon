class Admin::BadgesController < AdminController
  
  before_filter :find_badge, only: [:show, :edit, :update, :destroy]
  
  def index
    @badges = Badge.order("created_at desc").page(params[:page])
  end
  
  def show
  end
  
  def new
    @badge = Badge.new
  end
  
  def create
    parms = params[:badge]
    parms[:admin_id] = current_user.id
    if params[:redeem] == "purchase"
      parms[:code] = nil
      parms[:price] = (parms[:price].to_f * 100).to_i
    else
      parms[:price] = nil
    end
    @badge = Badge.create(parms)
    if @badge.valid?
      redirect_to edit_admin_badge_path(@badge), notice: "Badge saved!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:badge]
    parms[:admin_id] = current_user.id
    if params[:redeem] == "purchase"
      parms[:code] = nil
      parms[:price] = (parms[:price].to_f * 100).to_i
    else
      parms[:price] = nil
    end
    @badge.update_attributes(parms)
    if @badge.valid?
      redirect_to edit_admin_badge_path(@badge), notice: "Badge saved!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @badge.destroy
    redirect_to admin_badges_path, notice: "Badge deleted"
  end
  
  def mass_new
  end
  
  def mass_create
    num = params[:number].to_i
    badge_params = { :level => params[:badge_level], :explain => params[:explain], :admin_id => current_user.id }
    num.times do
      if params[:redeem] == "code"
        badge_params[:code] = SecureRandom.hex(4)
        badge_params[:price] = nil
      else
        badge_params[:code] = nil
        badge_params[:price] = (params[:price].to_f * 100).to_i
      end
      Badge.create(badge_params)
    end
    redirect_to admin_badges_path, notice: "Badges created"
  end
  
  private
    def find_badge
      @badge = Badge.find_by_id(params[:id])
      redirect_to :index, alert: "Sorry, couldn't find that badge" unless @badge.present?
    end
end
