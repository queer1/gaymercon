class PanelVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :panel
  after_save :recompute_panel
  after_save :grant_xp
  
  before_save :fb_publish
  after_destroy :fb_unpublish
  
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
  
  def fb_publish
    return unless self.user.present? && self.user.fb_token.present? && self.value_changed?
    if self.value.to_f > 0 && self.og_id.nil?
      og = OpenGraph.new(self.user.fb_token)
      response = og.publish('like', self )
      self.og_id = response["id"] if response.present?
    elsif self.value.to_f < 0 && self.og_id.present?
      og = OpenGraph.new(self.user.fb_token)
      og.unpublish(self.og_id)
      self.og_id = nil
    end
  end
  
  def fb_unpublish
    return unless self.user.present? && self.user.fb_token.present? && self.og_id.present?
    og = OpenGraph.new(self.user.fb_token)
    og.unpublish(self.og_id)
  end
end
