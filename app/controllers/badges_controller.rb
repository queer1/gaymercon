class BadgesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_badge, only: [:show, :edit, :update, :destroy]
  before_filter :not_implemented, only: [:index, :show, :create]
  
  def index
  end
  
  def show
  end
  
  def create
  end
  
  def new
    redirect_to edit_badge_path(current_user.badge) if current_user.badge.present?
    @badge = Badge.new
  end
  
  def edit
  end
  
  def update
    parms = params[:badge].slice(:address_1, :address_2, :city, :province, :country, :postal)
    @badge.update_attributes(parms)
    if @badge.valid?
      redirect_to edit_bagdes_path, notice: "Badge updated!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @badge.update_attributes(:user_id => nil, :address_1 => nil, :address_2 => nil, :city => nil, :province => nil, :country => nil, :postal => nil)
    redirect_to new_badge_path, notice: "You've unregistered for GaymerCon"
  end
  
  def register
    code = params[:code] || params[:badge].try(:[], :code)
    @badge = Badge.find_by_code(code)
    redirect_to new_badge_path, alert: "Sorry, invalid code" and return unless @badge.present?
    redirect_to new_badge_path, alert: "Sorry, that badge is already taken" and return if @badge.user_id.present?
    
    if request.post?
      parms = params[:badge].slice(:address_1, :address_2, :city, :province, :country, :postal)
      parms[:user_id] = current_user.id
      @badge.update_attributes(parms)
      if @badge.valid?
        redirect_to edit_badge_path(@badge), notice: "You're now registered for GaymerCon 2013!" and return
      else
        flash.now[:alert] = "Oops, there was a problem: #{@badge.all_errors}"
      end
    end
  end
  
  private
    def find_badge
      @badge = current_user.badge
      redirect_to new_badge_path, alert: "Sorry, couldn't find your badge. Have you registered?" unless @badge.present?
    end
    
    def not_implemented
      redirect_to current_user.badge.present? ? edit_badge_path : new_badge_path
    end
end
