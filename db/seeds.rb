puts "Add a default user (if one doesn't already exist)"
unless User.exists?(:conditions => {:email => "bdubs33@gmail.com"})
  usr = User.create(:email => "bdubs33@gmail.com", :name => "Ben", :password => "foobar", :password_confirmation => "foobar")
  usr.admin = true
  usr.save
end
