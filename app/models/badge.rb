class Badge < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  validates_uniqueness_of :code
  before_save :grant_xp
  
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
  
  def self.levels
    LEVELS
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
