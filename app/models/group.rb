class Group < ActiveRecord::Base
  include Locatable
  KINDS = ["game", "location", "interest", "guild", "official"]
  HEADER_DEFAULTS = {
    game: 'default_group_game.png',
    location: 'default_group_location.png',
    interest: 'default_group_interest.png',
    guild: 'default_group_guild.png',
    official: 'default_group_official.png'
  }
  belongs_to :moderator, :class_name => "User"
  has_many :posts, :class_name => "GroupPost"
  has_many :memberships
  has_many :users, :through => :memberships
  
  has_attached_file :header, :styles => { :large => "800x215#" }
  
  before_validation :set_game_key
  before_destroy :cleanup
  
  validates_inclusion_of :kind, :in => KINDS, :message => "is not a valid group type."
  validate :game_unique
  validates_presence_of :name
  validates_uniqueness_of :name
  
  acts_as_url :name, sync_url: true
  
  searchable do
    text :name, :description, :site_name, :site_link, :game, :game_key, :url
    string :kind
    string :klass do
      self.class.name
    end
    boolean :private
  end

  KINDS.each do |kind|
    scope kind.pluralize.to_sym, where(kind: kind)
  end
  scope :with_posts, select("groups.*, (COUNT(*) - 1) as post_count, group_posts.updated_at as last_post_date").joins("left outer join (select updated_at, group_id from group_posts order by updated_at desc) as group_posts on group_posts.group_id = groups.id").group("groups.id")

  def self.kinds
    KINDS
  end
  
  def self.header_defaults
    HEADER_DEFAULTS.with_indifferent_access
  end
  
  def default_header
    header = self.class.header_defaults[self.kind]
    header = "main-header.png" unless header.present?
    return header
  end
  
  def private?
    self.private
  end
  
  def member?(user)
    Membership.where(group_id: self.id, user_id: user.id).exists?
  end
  
  def random_members(n = 1)
    member_ids = self.users.select("users.id").all.collect(&:id)
    ret_ids = member_ids.sample(n)
    self.users.where("users.id in (?)", ret_ids).all
  end
  
  def visible_to?(user)
    return false unless user.present?
    user.mod? || self.users.where(id: user.id).exists?
  end
  
  def editor?(user)
    user.mod? || self.moderator_id == user.id
  end
  
  def last_post_date
    posts.order("created_at desc").first.try(:created_at)
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
  
  def to_param
    url
  end
  
  def game_group
    return nil unless self.kind != "game" && self.game_key.present?
    Group.where(kind: "game", game_key: self.game_key).first
  end
  
  def cleanup
    self.posts.destroy_all
    self.memberships.destroy_all
    Notification::GroupNotification.where(group_id: self.id).destroy
  end
end
