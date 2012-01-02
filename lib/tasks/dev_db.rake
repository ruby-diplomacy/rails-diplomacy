namespace :db do
  desc "initialize db with some sample data"
  task :dev_init => :environment do
    require 'factory_girl'
    Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}
    FactoryGirl.create :game
    FactoryGirl.create :user
  end
end
