class Badge < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  validates_uniqueness_of :code
  before_save :grant_xp
  
  LEVELS = {
    coin_entered: "General Access",
    boss_mode: "General Access + Fri night VIP party",
    boss_brunch: "General Access + Fri night VIP party + VIP brunch on Sunday",
    boss_lunch: "General Access + Fri night VIP party + VIP lunch on Sunday + VIP brunch on Sunday",
    artist: "General Access + table in Artist's Alley",
    exhibitor: "General Access + table in Exhibitor Hall",
    cheat_code: "General Access + Fri night VIP party + VIP lunch + VIP brunch + instant front-of-line at all events",
    backstage: "General Access + Fri night VIP party + VIP lunch + VIP brunch + backstage passes to Gaymer Concert",
    press: "All Access",
    special: "Industry / Special Guest pass: All Access",
    staff: "Staff"
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
