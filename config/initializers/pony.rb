Pony.options = { 
  :from => 'admin@gaymercon.org', 
  :via => :smtp,
  :via_options => EMAIL['smtp'].symbolize_keys
}