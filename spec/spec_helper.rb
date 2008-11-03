# ---- requirements
require 'rubygems'
require 'spec'
require 'mocha'

#strip_tags
require 'actionpack'
require 'action_controller'

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))


# ---- rspec
Spec::Runner.configure do |config|
  config.mock_with :mocha
end


# ---- bugfix
#`exit?': undefined method `run?' for Test::Unit:Module (NoMethodError)
#can be solved with require test/unit but this will result in extra test-output
unless defined? Test::Unit
  module Test
    module Unit
      def self.run?
        true
      end
    end
  end
end


# ---- load active record
#gem 'activerecord', '2.0.2'
require 'active_record'


RAILS_ENV = "test"
ActiveRecord::Base.configurations = {"test" => {
  :adapter => "sqlite3",
  :database => ":memory:",
}.with_indifferent_access}

ActiveRecord::Base.logger = Logger.new(File.directory?("log") ? "log/#{RAILS_ENV}.log" : "/dev/null")
ActiveRecord::Base.establish_connection(:test)


# ---- setup environment/plugin
require File.expand_path("../init", File.dirname(__FILE__))
load File.expand_path("setup_test_model.rb", File.dirname(__FILE__))


# ---- fixtures
Spec::Example::ExampleGroupMethods.module_eval do
  def fixtures(*tables)
    dir = File.expand_path("fixtures", File.dirname(__FILE__))
    tables.each{|table| Fixtures.create_fixtures(dir, table.to_s) }
  end
end