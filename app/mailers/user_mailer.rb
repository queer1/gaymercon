class UserMailer < ActionMailer::Base
  default from: "admin@gaymercon.org"
  
  def welcome(user)
    @title = "Welcome to GaymerCon"
    @user = user
    @url  = "https://www.gaymercon.org/users/edit"
    @header = "email_header.png"
    headers = {:to => user.email, :subject => @title}
    headers[:delivery_method] = :test if @user.disable_emails
    mail(headers)
  end
  
  def new_pm(pm)
    @user = pm.to_user
    @title = "New Private Message From #{pm.from_user.name}"
    @header = "email_header.png"
    @pm = pm
    headers = {:to => @user.email, :subject => @title}
    headers[:delivery_method] = :test if @user.disable_emails || @user.disable_pm_emails
    mail(headers)
  end
  
  def new_donation(donation)
    @title = "Thanks for your donation!"
    @header = "email_header.png"
    @donation = donation
    headers = {:to => donation.email, :subject => @title}
    mail(headers)
  end
  
  def mass_mail(record)
    @header = "gaymerXheader.png"
    @title = record.subject
    @record = record
    headers = {:to => @record.email, :subject => @title}
    mail(headers)
  end
  
  def gift_badge(email, badge, cc = nil)
    @user = badge.purchaser
    @badge = badge
    @title = "#{@user.name} has given you a badge for GaymerX!"
    @header = "gaymerXheader.png"
    headers = {:to => email, :subject => @title}
    mail(headers)
  end
end
