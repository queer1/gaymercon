class WelcomeController < ApplicationController
  before_filter :section_name
  before_filter :header_img
  
  def index
    if params[:email] && params[:antispam]
      @gaymer.create(email: params[:email], city: params[:city], age: params[:age])
      if @gaymer.persisted?
        flash.now[:notice] = "You're in the loop!"
      else
        flash.now[:error] = "There was a problem: #{@gaymer.errors.full_messages.join("<br /")}"
      end
    end
  end
  
  def about
  end
  
  def location
  end
  
  def contact
    if params[:email].present? && params[:antispam]
      message = "New Message from #{params[:email]}\n\n#{params[:message]}"
      Pony.mail({
        :to => 'site@gaymercon.org',
        :from => params[:email],
        :subject => params[:subject],
        :body => message
      })
      flash.now[:notice] = "Thanks! We'll get back to you as soon as we can."
    end
  end
  
  def volunteer
    if params[:email].present? && params[:antispam]
      message = "#{params[:email]} wants to volunteer!\n\n#{params[:message]}"
      Pony.mail({
        :to => 'site@gaymercon.org',
        :from => params[:email],
        :subject => "Volunteering for GaymerCon",
        :body => message
      })
      flash.now[:notice] = "Thanks a ton! We'll get back to you ASAP."
    end
  end
  
  def credits
  end
  
  def donate
    if request.post?
      result = stripe_donate
      flash.now[:alert] = result if result.is_a?(String)
    end
  end
  
  def get_location
    render :json => {:location => "San Francisco, CA"} and return if Rails.env == "development"
    result = Geoip.lookup(request.remote_ip)
    response = result.present? ? {:location => "#{result[:city]}, #{result[:country_code]}"} : {}
    render :json => response
  end
  
  private
    def stripe_donate
      email = current_user.present? ? current_user.email : params[:email]
      return "Please enter your name and a valid email" unless email.present? && email =~ /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i && params[:first_name].present? && params[:last_name].present?
      return "Please tell us why you're donating" unless params[:notes].present?
      # amount has to be in cents
      amount = params[:amount]
      amount = (params[:amount_other].to_f * 100) if amount == "other" && params[:amount_other]
      amount = amount.to_i
      return "Please enter a valid amount." unless amount.is_a?(Integer) && amount > 99
      return "Sorry, couldn't process your card. Please try again, and make sure javascript is enabled." unless params[:token].present?
      charge = Stripe::Charge.create(
        :amount => amount,
        :currency => "usd",
        :card => params[:token],
        :description => "Donation from #{email}"
      )
      return "Oops, there was a problem: #{charge.message}" if charge.is_a?(Stripe::StripeError)
      donator = Donator.donate(params.merge({current_user: current_user, amount: amount, email: email}))
      
      sp = { amount: amount, token: params[:token], description: "Donation from #{email}", stripe_id: charge.id, paid: charge.paid }
      sp[:user_id] = current_user.id if current_user.present?
      sp[:donator_id] = donator.id
      payment = StripePayment.create(sp)
      flash.now[:notice] = "Thanks for donating! GaymerCon loves you!"
      
      payment
    end
    
    def section_name
      @section_name = "GaymerCon"
    end
    
    def header_img
      @header_img = "main-header.png"
    end
end
