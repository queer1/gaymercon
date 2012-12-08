class User < ActiveRecord::Base
  include Locatable
  
  # user.coords = user's coordinates
  # user.place = string location for user
  # user.location = Mongoid doc with location coords and query methods
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :fb_token, :fb_expires, :tw_token, :tw_expires # omniauth
  attr_accessible :disable_emails, :disable_pm_emails
  attr_accessible :name, :job_id
  attr_accessible :strength, :agility, :vitality, :mind, :xp
  attr_accessor :leveled_up
  
  has_many :forum_threads
  has_many :forum_posts
  has_many :panels
  has_many :panel_votes
  has_many :graffitis
  has_many :tags, :through => :graffitis
  has_many :messages, foreign_key: 'to_user_id', class_name: "Message"
  has_many :sent_messages, foreign_key: 'from_user_id', class_name: "Message"
  has_many :alerts, class_name: "UserAlert"
  has_many :admin_badges, foreign_key: "admin_id", class_name: "Badge"
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :nicknames
  
  has_one :badge
  
  belongs_to :job
  
  validate :check_skills
  
  after_save :level_up
  before_destroy :cleanup
  
  # blegh. debugged on production
  def avatar
    return "default_user.png" unless self.job_id.present?
    the_job = Job.where(id: self.job_id).first
    return "default_user.png" unless the_job.present?
    the_job.icon_path
  end
  
  def admin?
    self.role == "admin"
  end
  
  def mod?
    self.admin? || self.role == "mod"
  end
  
  def banned?
    self.role == "banned"
  end
  
  def unread_message_count
    self.messages.where(read: false).count
  end
  
  # Level Stuff
  def level
    LevelCalculator.level(self.xp)
  end
  
  def progress
    LevelCalculator.progress(self.xp)
  end
  
  def level_up
    return unless self.xp_changed?
    level_was = LevelCalculator.level(self.xp_was)
    level_is = LevelCalculator.level(self.xp)
    if(level_was < level_is)
      self.skill_points += level_is - level_was
      self.leveled_up = true
      self.alerts.create(message: "LEVEL UP! You are now level #{level_is}")
    end
  end
  
  def free_skill_points
    skill_points - strength - agility - vitality - mind
  end
  
  # Tag shenanigans
  def game_groups
    self.groups.where(kind: "game").all
  end
  
  def games=(games = [])
    gids = self.groups.where(kind: 'game').collect(&:id)
    Membership.where(user_id: self.id, group_id: gids).destroy_all
    add_games(games)
  end
  
  def games
    self.groups.where(kind: 'game').collect(&:game)
  end
  
  def add_games(games)
    games.each { |game| add_game(game) }
  end
  
  def add_game(game)
    return unless game.present?
    group = Group.where(game_key: game.to_url).first
    group ||= Group.create(name: game, game: game, game_key: game.to_url, kind: 'game')
    Membership.where(user_id: self.id, group_id: group.id).first_or_create
    group
  end
  
  def coplayers
    gids = self.groups.where(kind: 'game').select("groups.id").collect(&:id)
    return [] unless gids.present?
    User.find_by_sql(<<-SQL
      SELECT u.*, COUNT(*) as coplays
      FROM memberships m
      LEFT JOIN users u ON u.id = m.user_id
      WHERE m.group_id IN (#{gids.join(',')})
      AND m.user_id != #{self.id}
      GROUP BY m.user_id
      HAVING coplays > 0
    SQL
    ).reject{|u| u.id.nil? }
  end
  
  def games_in_common(other_user)
    self.games & other_user.games
  end
  
  # Notifications
  def notifications
    Notification.where(user_id: self.id).desc(:updated_at)
  end
  
  # Validationz
  
  def check_skills
    stats = [strength, agility, vitality, mind]
    return true if stats.all?{|s| s == 1 }
    errors.add(:base, "Your stats seem a bit high ;)") if stats.sum > self.skill_points
    [:strength, :agility, :vitality, :mind].each do |stat|
      errors.add(stat, "can't be below minimum of 7") if self.send(stat) < 7
      errors.add(stat, "went down. Contact us about a re-spec ;)") if self.send("#{stat}_changed?".to_sym) && self.send(stat) < self.send("#{stat}_was".to_sym)
    end
  end
  
  def check_job
    return true if !self.job_id.present? || Job.for_user(self).include?(self.job)
    errors.add(:base, "Please pick one of the available jobs.")
  end
  
  def cleanup
    # leave groups, comments, etc, so content doesn't suddenly disappear because a user quit
    Notification.where(user_id: self.id).destroy
    self.location.destroy
    self.memberships.destroy_all
    self.nicknames.destroy_all
    self.alerts.destroy_all
  end
  
  # Omniauth
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = signed_in_resource
    user ||= User.where(:provider => auth.provider, :uid => auth.uid).first
    user ||= User.where(:email => auth.info.email).first
    user ||= User.where(:name => auth.extra.raw_info.name).first
    if user.present?
      user.update_attributes( provider: auth.provider, 
        uid: auth.uid, 
        fb_token: auth.credentials.token, 
        fb_expires: Time.at(auth.credentials.expires_at.to_i) 
      )
    else
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           fb_token: auth.credentials.token, 
                           fb_expires: Time.at(auth.credentials.expires_at.to_i),
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           job_id: 1,
                           xp: 1000
                           )
      # pull games from facebook
      fb_user = FbGraph::User.me(user.fb_token)
      likes = fb_user.likes.select {|l| l.category == 'Games/toys' }
      likes.collect!(&:name)
      user.add_games(likes)
      user.save
    end

    return user
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = signed_in_resource
    user ||= User.where(:provider => auth.provider, :uid => auth.uid).first
    user ||= User.where(:name => auth.extra.raw_info.name).first
    if user.present?
      user.update_attributes( provider: auth.provider, 
        uid: auth.uid, 
        tw_token: auth.credentials.token, 
        tw_expires: Time.at(auth.credentials.expires_at.to_i) 
      )
    else
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           tw_token: auth.credentials.token, 
                           tw_expires: Time.at(auth.credentials.expires_at.to_i),
                           email:"#{auth.extra.raw_info.screen_name}@twitter.com",
                           password:Devise.friendly_token[0,20],
                           job_id: 1,
                           xp: 1000
                           )
    end

    user.save
    user
  end
end
