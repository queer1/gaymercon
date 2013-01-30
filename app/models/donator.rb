class Donator < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :stripe_payments
  after_create :grant_xp
  after_create :send_email
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def self.donate(opts = {})
    opts = opts.with_indifferent_access
    Rails.logger.debug opts.inspect
    donator = nil
    donator = Donator.find_or_initialize_by_user_id(opts[:current_user].id) if opts[:current_user]
    donator ||= Donator.find_or_initialize_by_email(opts[:email]) if opts[:email]
    donator ||= Donator.where(first_name: opts[:first_name], last_name: opts[:last_name]).first_or_initialize if opts[:name]
    donator.email = opts[:email] if opts[:email]
    donator.first_name = opts[:first_name] if opts[:first_name]
    donator.last_name = opts[:last_name] if opts[:last_name]
    donator.amount = opts[:amount]
    donator.notes = opts[:notes]
    if opts[:subscribe]
      donator.subscribed = true
      list_id = MAILCHIMP_CONFIG['donators_list']
      retry_times = 0
      begin
        MAILCHIMP.list_subscribe(list_id, donator.email, {'FNAME' => donator.first_name}, 'html', false, true, true, false)
      rescue EOFError => eof
        retry_times += 1
        retry unless retry_times > 1
        Coalmine.notify(eof, options: opts)
        Rails.logger.error("#{eof.inspect}\n#{eof.message}\n\nbacktrace:\n#{eof.backtrace.join("\n")}")
      rescue Exception => e
        Coalmine.notify(e, options: opts)
        Rails.logger.error("#{e.inspect}\n#{e.message}\n\nbacktrace:\n#{e.backtrace.join("\n")}")
      end
    end
    donator.save
    donator
  end
  
  def name
    "#{first_name} #{last_name}"
  end

  def amount_in_dollars
    (self.amount.to_f / 100)
  end
  
  def grant_xp
    return unless self.user.present?
    self.user.xp += self.amount
    self.user.save
  end
  
  def send_email
    UserMailer.new_donation(self).deliver
    Pony.mail(to: "donations@gaymerconnect.com",
              from: self.email,
              subject: "New donation from #{self.first_name} #{self.last_name}",
              body: "#{self.name} donated $#{self.amount_in_dollars.round(2)}. Check it out at http://www.gaymerconnect.com/admin/donators\n\nNotes:\n\n#{self.notes}"
              )
  end
end
