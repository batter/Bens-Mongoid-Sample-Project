# config
admin_name = "Ben" # Not needed for sign-in; merely for aesthetics
admin_email = "bdubs33@gmail.com"
admin_password = "foobar"

puts "Add an admin user (if one doesn't already exist)"
unless User.exists?(:conditions => {:email => admin_email})
  usr = User.create(:email => admin_email, :name => admin_name, :password => admin_password, :password_confirmation => admin_password)
  usr.toggle_admin!
end