class PanelVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :panel
  after_save :recompute_panel
  
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
end
