require 'require_all'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/database.db")

require_all 'models'

DataMapper.auto_upgrade! # if ARGV[1] == 'migrate'

# SEEDING KIND OF
if User.first.nil?
  admin = User.create(:id => 1, :ip => '12.12.12.12', :name => 'admin', :password => 'admin')
  admin.save
end


