class WelcomeController < ApplicationController
  
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
  
  def contact
    if params[:email] && params[:antispam]
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
    if params[:email] && params[:antispam]
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
end
