class Badge < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  has_one :stripe_payment
  validate :price_or_code
  before_save :grant_xp
  scope :purchasable, where("price IS NOT NULL and user_id IS NULL")
  
  LEVELS = {
    coin_entered: "General Access",
    boss_mode: "General Access + Fri night VIP party",
    artist_ga: "General Access + table in Artist's Alley",
    artist_boss: "Boss Mode + table in Artist's Alley",
    exhibitor: "Boss Mode + VIP Party + table in Exhibitor Hall",
    cheat_code: "Boss Mode + VIP party + instant front-of-line at all events",
    backstage: "Boss Mode + VIP party + backstage passes to Gaymer Concert",
    press: "All Access",
    special: "Industry / Special Guest pass: All Access",
    staff: "All Access"
  }.with_indifferent_access
  
  validates_inclusion_of :level, :in => LEVELS.keys
  
  def self.redeemed_count
    self.where("user_id IS NOT NULL").count
  end
  
  def self.levels
    LEVELS
  end
  
  def self.purchasable_levels
    lvls = self.where("price IS NOT NULL and user_id IS NULL").select("level").group("level").collect(&:level)
    LEVELS.slice(*lvls)
  end
  
  def self.find_for_purchase(level)
    excluded = REDIS.zrangebyscore("badge_reserve", "(#{Time.now.to_i}", "+inf")
    excluded = [-1] unless excluded.present?
    self.purchasable.where("id NOT IN (?)", excluded).order("price asc").first
  end
  
  def self.price(level)
    self.purchasable.where("level = ?", level).order("price asc").first.try(:price)
  end
  
  def price_or_code
    return true if price.present?
    errors.add(:code, "is already in use") if Badge.where("id != ? and code = ?", (self.id || -1), self.code).exists?
  end
  
  def purchasable?
    price.present? && user_id.nil?
  end
  
  def reserve
    REDIS.zadd("badge_reserve", (Time.now + 15.minutes).to_i, self.id)
  end
  
  def price_in_dollars
    price.to_f / 100
  end
  
  def description
    LEVELS[self.level]
  end
  
  def grant_xp
    return unless self.user_id_changed? && self.user_id_was == nil && self.user.present?
    self.user.xp += 1000
    self.user.save
  end
  
end
