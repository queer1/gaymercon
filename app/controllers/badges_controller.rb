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
    parms = params[:badge].slice(:name, :age, :address_1, :address_2, :city, :province, :country, :postal)
    @badge.update_attributes(parms)
    if @badge.valid?
      redirect_to edit_badge_path(@badge), notice: "Badge updated!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @badge.update_attributes(:user_id => nil, :address_1 => nil, :address_2 => nil, :city => nil, :province => nil, :country => nil, :postal => nil)
    redirect_to new_badge_path, notice: "You've unregistered for GaymerCon"
  end
  
  # html form for purchasing a badge
  def purchase
    @badge = Badge.find_by_id(session[:purchase_badge])
    unless @badge.present? && @badge.purchasable?
      session[:purchase_badge] = nil
      @badge = nil
    end
    
    level = params[:badge_level] || "coin_entered"
    @badge ||= Badge.find_for_purchase(level)
    redirect_to new_badge_path, alert: "Sorry, looks like all the badges at that level are taken" and return unless @badge.present?
    
    @badge.reserve
    session[:purchase_badge] = @badge.id
  end
  
  # process badge purchase
  def buy
    @badge = Badge.find_by_id(params[:badge]["id"])
    redirect_to purchase_badges_path, alert: "Sorry, the badge you were going to buy got taken :(" and return unless @badge.present? && @badge.purchasable?
    
    fields = ["first_name", "last_name", "age", "address_1", "city", "province", "country", "postal"]
    badge_params = params[:badge].slice(*(fields + ["address_2"]))
    @badge.assign_attributes(badge_params)
    unless fields.all?{|f| @badge.send(f).present? }
      flash.now[:alert] = "Please fill out all the badge info."
      render :purchase and return
    end
    result = process_payment(@badge)
    redirect_to edit_badge_path(@badge), notice: "You've purchased a badge! Aren't you awesome?" and return if result.is_a?(Badge)
    flash.now[:alert] = result
    render :purchase
  end
  
  def register
    code = params[:code] || params[:badge].try(:[], :code)
    @badge = Badge.find_by_code(code)
    redirect_to new_badge_path, alert: "Sorry, invalid code" and return unless @badge.present?
    redirect_to new_badge_path, alert: "Sorry, that badge is already taken" and return if @badge.user_id.present?
    
    if request.post?
      fields = ["first_name", "last_name", "age", "address_1", "city", "province", "country", "postal"]
      parms = params[:badge].slice(*(fields + ["address_2"]))
      parms[:user_id] = current_user.id
      @badge.update_attributes(parms)
      
      if @badge.valid? && fields.all?{|f| @badge.send(f).present? }
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
    
    def process_payment(badge)
      return "Sorry, couldn't process your card. Please try again, and make sure javascript is enabled." unless params[:token].present?
      charge = Stripe::Charge.create(
        :amount => badge.price,
        :currency => "usd",
        :card => params[:token],
        :description => "Purchase badge #{badge.id}"
      )
      return "Oops, there was a problem: #{charge.message}" if charge.is_a?(Stripe::StripeError)
      
      sp = { amount: badge.price, token: params[:token], description: "Purchase badge #{badge.id}", stripe_id: charge.id, paid: charge.paid, badge_id: badge.id }
      sp[:user_id] = current_user.id
      payment = StripePayment.create(sp)
      return payment.all_errors unless payment.valid?
      if badge.update_attributes(:user_id => current_user.id)
        return badge
      else
        return "Your payment has been processed, but there was a problem saving your badge: #{badge.all_errors}. Please contact the admins."
      end
    end
end
