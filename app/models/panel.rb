class Panel < ActiveRecord::Base
  belongs_to :user
  has_many :panel_votes
  
  after_save :grant_xp
  
  # reddit algorithm, as stolen from here: 
  # http://www.seomoz.org/blog/reddit-stumbleupon-delicious-and-hacker-news-algorithms-exposed
  def compute_score
    ts = self.created_at - Time.parse("January 1, 2012")
    x = PanelVote.difference(self.id)
    y = x > 0 ? 1 : (x < 0 ? -1 : 0)
    z = x < 0 ? x * -1 : x
    z = 1 if z < 1
    self.score = Math.log(z, 10) * ((y * ts) / 45000)
    self.save
  end
  
  def vote(user_id)
    self.panel_votes.where(user_id: user_id).first
  end
  
  def grant_xp
    return if self.class.where("user_id = ?", self.user_id).count > 1
    self.user.xp += 100
    self.user.save
  end
end
