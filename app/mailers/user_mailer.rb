class UserMailer < ActionMailer::Base
  default from: "admin@gaymercon.org"
  
  def welcome(user)
    @title = "Welcome to GaymerCon"
    @user = user
    @url  = "https://www.gaymercon.org/users/edit"
    headers = {:to => user.email, :subject => @title}
    headers[:delivery_method] = :test if @user.disable_emails
    mail(headers)
  end
  
  def new_pm(pm)
    @user = pm.to_user
    @title = "New Private Message From #{pm.from_user.name}"
    @pm = pm
    headers = {:to => @user.email, :subject => @title}
    headers[:delivery_method] = :test if @user.disable_emails || @user.disable_pm_emails
    mail(headers)
  end
  
  def new_donation(donation)
    @title = "Thanks for your donation!"
    @donation = donation
    headers = {:to => donation.email, :subject => @title}
    mail(headers)
  end
  
  def mass_mail(record)
    @title = record.subject
    @record = record
    headers = {:to => @record.email, :subject => @title}
    mail(headers)
  end
end
