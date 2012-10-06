class Group < ActiveRecord::Base
  include Locatable
  KINDS = ["game", "location", "interest", "guild", "official"]
  belongs_to :moderator, :class_name => "User"
  has_many :posts, :class_name => "GroupPost"
  has_many :memberships
  has_many :users, :through => :memberships
  
  has_attached_file :header, :styles => { :large => "1000x191#" }
  
  before_validation :set_game_key
  validates_inclusion_of :kind, :in => KINDS, :message => "is not a valid group type."
  validate :game_unique
  
  def self.kinds
    KINDS
  end
  
  def member?(user)
    Membership.where(group_id: self.id, user_id: user.id).exists?
  end
  
  def editor?(user)
    user.mod? || self.moderator_id == user.id
  end
  
  def latest_posts(num = 10)
    posts.order("updated_at desc").limit(10).all
  end
  
  def set_game_key
    self.game_key = self.game.present? ? self.game.to_url : nil
  end
  
  def game_unique
    return unless self.kind == "game"
    if Group.where("game_key = ? and kind = 'game' and id != ?", self.game_key, self.id).exists?
      errors[:base] << "There is already a group for that game. Is your group a guild?"
    end
  end
  
  def game_group
    return nil unless self.kind != "game" && self.game_key.present?
    Group.where(kind: "game", game_key: self.game_key).first
  end
  
  def self.forums
    forum_groups = ["GaymerCon", "The Site", "General Chat"]
    forum_groups.collect {|fg| Group.where(name: fg, kind: 'official').first_or_create }
  end
end
