require 'faker'


namespace :db do
  desc "fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!( :name => "Example User",
                  :email => "example@railstutorial.org",
                  :password => "foobar",
                  :password_confirmation => "foobar")
    admin.toggle! :admin
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      user = User.create!({
        :name => name,
        :email => email,
        :password => password,
        :pasword_confirmation => password
      })
      50.times do |m|
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end  
  end  
end  
