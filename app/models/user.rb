class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :fb_token, :fb_expires # omniauth
  attr_accessible :disable_emails, :disable_pm_emails
  attr_accessible :name, :job_id, :location
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
  
  has_one :badge
  
  belongs_to :job
  
  validate :check_skills
  
  before_save :set_coords
  before_save :level_up
  
  def avatar
    self.job_id ? self.job.icon_path : "default_user.png"
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
  def add_tag(kind, tag)
    tag = Tag.where(name: tag).first_or_create if tag.is_a?(String) || tag.is_a?(Symbol)
    kind = kind.to_s
    g = Graffiti.where(kind: kind, tag_id: tag.id, user_id: self.id).first
    g ||= self.graffitis.create(kind: kind, tag_id: tag.id)
    g.persisted? && tag.persisted?
  end
  
  def remove_tag(kind, tag)
    tag = Tag.where(name: tag).first_or_create if tag.is_a?(String) || tag.is_a?(Symbol)
    kind = kind.to_s
    g = Graffiti.where(kind: kind, tag_id: tag.id, user_id: self.id).first
    g.destroy if g.present?
  end
  
  def games
    tag_ids = self.graffitis.where("kind = 'games'").all.collect(&:tag_id)
    self.tags.where("tags.id IN (?)", tag_ids).all.collect(&:name)
  end
  
  def check_skills
    stats = [strength, agility, vitality, mind]
    return true if stats.all?{|s| s == 1 }
    errors.add(:base, "Your stats seem a bit high ;)") if stats.sum > self.skill_points
    [:strength, :agility, :vitality, :mind].each do |stat|
      errors.add(stat, "can't be below minimum of 7") if self.send(stat) < 7
      errors.add(stat, "went down. Contact us about a re-spec ;)") if self.send("#{stat}_changed?".to_sym) && self.send(stat) < self.send("#{stat}_was".to_sym)
    end
  end
  
  # Location shenanigans
  def set_coords
    self.place.coords = PlaceFinder.coords(self.location) if self.location.present? && self.location_changed?
    self.place.save
    true
  end
  
  def place
    return @place if @place.present?
    @place = Location.find_or_create_by(user_id: self.id)
  end
  
  def coords
    self.place.coords
  end

  def distance_from(point_arr)
    Geocalc.distance_between(self.coords, point_arr)
  end
  
  # Omniauth
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    user ||= User.where(:email => auth.info.email).first
    if user.present?
      user.update_attributes( provider: auth.provider, 
        uid: auth.uid, 
        fb_token: auth.credentials.token, 
        fb_expires: Time.at(auth.credentials.expires_at) 
      )
    else
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           fb_token: auth.credentials.token, 
                           fb_expires: Time.at(auth.credentials.expires_at),
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           job_id: 1
                           )
    end

    # pull games from facebook
    # fb_user = FbGraph::User.me(user.fb_token)
    #     likes = fb_user.likes.select {|l| l.category == 'Games/toys' }
    #     likes.each {|l| user.games << l.name }
    user.save
    user
  end
end
