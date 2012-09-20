class Donator < ActiveRecord::Base
  
  has_many :stripe_payments
  after_create :grant_xp
  
  def self.donate(opts = {})
    opts = opts.with_indifferent_access
    Rails.logger.debug opts.inspect
    donator = nil
    donator = Donator.find_or_initialize_by_user_id(opts[:current_user].id) if opts[:current_user]
    donator ||= Donator.find_or_initialize_by_email(opts[:email]) if opts[:email]
    donator ||= Donator.find_or_initialize_by_name(opts[:name]) if opts[:name]
    donator.email = opts[:email] if opts[:email]
    donator.name = opts[:name] if opts[:name]
    donator.amount = opts[:amount]
    if opts[:subscribe]
      donator.subscribed = true
      list_id = MAILCHIMP_CONFIG['donators_list']
      begin
        MAILCHIMP.list_subscribe(list_id, donator.email, {'FNAME' => donator.name}, 'html', false, true, true, false)
      rescue Exception => e
        Coalmine.notify(e, options: opts)
        Rails.logger.error(e.message + "\n\nbacktrace:\n#{e.backtrace.join("\n")}")
      end
    end
    donator.save
    donator
  end
  
  def grant_xp
    return unless self.user.present?
    self.user.xp += self.amount
    self.user.save
  end
end
