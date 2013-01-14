class BadgesController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :new_code]
  before_filter :find_badge, only: [:show, :edit, :update, :destroy]
  before_filter :not_implemented, only: [:show, :create]
  before_filter :setup_badge_list, only: [:index, :new_code, :edit]
  before_filter do @section_name = "Con Badge" end
  
  def index
  end
  
  def show
  end
  
  def create
  end
  
  def new
    session[:user_return_to] = new_badge_path unless current_user.present?
    @badge = Badge.new
  end
  
  def new_code
    session[:user_return_to] = new_code_badges_path unless current_user.present?
    @badge = Badge.new
  end
  
  def edit
  end
  
  def update
    parms = params[:badge].slice(:badge_name, :first_name, :last_name, :age, :address_1, :address_2, :city, :province, :country, :postal)
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
    @badge = Badge.purchasable.where(id: session[:purchase_badge]).first
    if @badge.nil? || !@badge.purchasable? || (params[:badge_level].present? && @badge.level != params[:badge_level])
      session[:purchase_badge] = nil
      @badge = nil
    end
    
    @for_code = params[:for_code]
    
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
    
    @for_code = params[:badge][:for_code]
    result = "Oops, there was an error processing your payment."
    if @for_code.present?
      result = process_payment(@badge, for_code: true)
    else
      fields = ["badge_name", "first_name", "last_name", "age", "address_1", "city", "province", "country", "postal"]
      badge_params = params[:badge].slice(*(fields + ["address_2"]))
      badge_params["badge_name"] ||= current_user.name
      @badge.assign_attributes(badge_params)
      unless fields.all?{|f| @badge.send(f).present? }
        flash.now[:alert] = "Please fill out all the badge info."
        render :purchase and return
      end
      result = process_payment(@badge)
    end
    
    if result.is_a?(Badge)
      session[:purchase_badge] = nil
      if @for_code
        begin
          UserMailer.gift_badge(params[:email], result).deliver if params[:email].present?
          UserMailer.gift_badge(current_user.email, result).deliver if params[:cc_me].present? && current_user.email.present?
        rescue Exception => e
          Coalmine.notify(e)
          flash[:alert] = "Your badge code has been purchased, but there was a problem sending the email."
        end
        redirect_to badges_path, notice: "You've purchased badge code #{result.code}!" and return
      else
        redirect_to edit_badge_path(@badge), notice: "You've purchased a badge! Aren't you awesome?" and return
      end
    end
    flash.now[:alert] = result
    render :purchase
  end
  
  # process code entry
  def register
    code = params[:code] || params[:badge].try(:[], :code)
    @badge = Badge.find_by_code(code)
    redirect_to new_badge_path, alert: "Sorry, invalid code" and return unless @badge.present?
    redirect_to new_badge_path, alert: "Sorry, that badge is already taken" and return if @badge.user_id.present?
    
    if request.post?
      fields = ["badge_name", "first_name", "last_name", "age", "address_1", "city", "province", "country", "postal"]
      parms = params[:badge].slice(*(fields + ["address_2"]))
      parms[:user_id] = current_user.id
      parms["badge_name"] ||= current_user.name
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
    
    def setup_badge_list
      @badges = []
      @badges << current_user.badge
      @badges += current_user.purchased_codes
      @badges.compact!
    end
    
    def process_payment(badge, opts = {})
      return "Sorry, couldn't process your card. Please try again, and make sure javascript is enabled." unless params[:token].present?
      begin
        charge = Stripe::Charge.create(
          :amount => badge.price,
          :currency => "usd",
          :card => params[:token],
          :description => "Purchase badge #{badge.id}"
        )
      rescue Stripe::StripeError => se
        return "Oops, there was a problem: #{se.message}"
      end
      return "Oops, there was a problem: #{charge.message}" if charge.is_a?(Stripe::StripeError)
      
      sp = { amount: badge.price, token: params[:token], description: "Purchase badge #{badge.id}", stripe_id: charge.id, paid: charge.paid, badge_id: badge.id }
      sp[:user_id] = current_user.id
      payment = StripePayment.create(sp)
      return payment.all_errors unless payment.valid?
      
      if opts[:for_code]
        badge_code = nil
        begin
          badge_code = SecureRandom.hex(4)
        end while Badge.where(code: badge_code).exists?
        
        if badge.update_attributes(:purchaser_id => current_user.id, code: badge_code)
          return badge
        else
          return "Your payment has been processed, but there was a problem saving your badge: #{badge.all_errors}. Please contact the admins."
        end
      end
      
      if badge.update_attributes(:user_id => current_user.id, :purchaser_id => current_user.id)
        return badge
      else
        return "Your payment has been processed, but there was a problem saving your badge: #{badge.all_errors}. Please contact the admins."
      end
    end
end
