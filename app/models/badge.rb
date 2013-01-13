class Badge < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  belongs_to :purchaser, :class_name => "User"
  has_one :stripe_payment
  validate :price_or_code
  before_save :grant_xp
  scope :purchasable, where("code IS NULL and price IS NOT NULL and user_id IS NULL and purchaser_id IS NULL")
  
  LEVELS = {
    coin_entered: "General Access",
    boss_mode: "General Access + Fri night VIP party + Tshirt + Swag Bag",
    artist: "Table in Artist's Alley",
    artist_boss: "Boss Mode + table in Artist's Alley + Tshirt + Swag Bag",
    exhibitor: "Boss Mode + VIP Party + table in Exhibitor Hall + Tshirt + Swag Bag",
    cheat_code: "Boss Mode + VIP party + instant front-of-line at all events + Tshirt + Swag Bag",
    backstage: "Boss Mode + VIP party + backstage passes to Gaymer Concert + Tshirt + Swag Bag",
    press: "All Access",
    special: "Industry / Special Guest pass: All Access",
    staff: "All Access"
  }.with_indifferent_access
  
  validates_inclusion_of :level, :in => LEVELS.keys
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def filled_out?
    ["user_id", "address_1",  "city", "province",  "country",  "postal", "age", "first_name",  "last_name"].all? do |f|
      self.send(f).present?
    end
  end
  
  def self.redeemed_count
    self.where("user_id IS NOT NULL").count
  end
  
  def self.levels
    LEVELS
  end
  
  def self.purchasable_levels
    lvls = self.purchasable.select("level").group("level").collect(&:level)
    ret = {}
    # maintain order in LEVELS hash
    LEVELS.each {|k,v| ret[k] = v if lvls.include?(k.to_s) }
    return ret
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
