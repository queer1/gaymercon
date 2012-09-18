class Badge < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  validates_uniqueness_of :code
  
  LEVELS = {
    coin_entered: "General Access",
    boss_mode: "General Access + VIP party & VIP brunch",
    artist: "General Access + table in Artist's Alley",
    exhibitor: "General Access + table in Exhibitor Hall",
    cheat_code: "General Access + instant front-of-line",
    backstage: "All Access",
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
  
end
