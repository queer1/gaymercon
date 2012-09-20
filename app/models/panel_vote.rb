class PanelVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :panel
  after_save :recompute_panel
  after_save :grant_xp
  
  def self.difference(panel_id)
    diff = self.connection.select_value("SELECT SUM(value) FROM panel_votes WHERE panel_id = #{panel_id}")
    diff ||= 0
    diff
  end
  
  def difference
    self.class.difference(self.panel_id)
  end
  
  def recompute_panel
    self.panel.compute_score
  end
  
  def grant_xp
    return if self.class.where("updated_at > ? and user_id = ?", Date.today, self.user_id).count > 10
    self.user.xp += 5
    self.user.save
  end
end
