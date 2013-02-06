module UsersHelper
  def common_games(user, other_user)
    (user.game_groups & other_user.game_groups).collect{|g| link_to(g.name, group_path(g))}.join(", ").html_safe
  end
  
  def common_networks(user, other_user)
    (other_user.network_names & user.network_names).collect(&:humanize).join(", ").html_safe
  end
end
