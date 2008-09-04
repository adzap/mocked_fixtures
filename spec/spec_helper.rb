$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'spec'

vendored_rails = File.dirname(__FILE__) + '/../../../../vendor/rails'

if vendored = File.exists?(vendored_rails)
  Dir.glob(vendored_rails + "/**/lib").each { |dir| $:.unshift dir }
else
  gem 'rails', "=#{ENV['VERSION']}" if ENV['VERSION']
end

require 'rails/version'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'active_record/version'

puts "Using #{vendored ? 'vendored' : 'gem'} Rails version #{Rails::VERSION::STRING} (ActiveRecord version #{ActiveRecord::VERSION::STRING})"

require 'rspec-rails/rspec-rails'

require 'mocked_fixtures/testcase'
require 'mocked_fixtures/schema_parser'
require 'mocked_fixtures/mock_fixtures'
require 'mocked_fixtures/mock_factory'
require 'mocked_fixtures/mock_connection'

require 'resources/company'
require 'resources/employee'

MockedFixtures::SchemaParser.schema_path = File.expand_path(File.dirname(__FILE__) + '/resources/schema.rb')

Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__) + '/resources')

ActiveRecord::Migration.verbose = false

ActiveRecord::Base.configurations['sqlite'] = {
  :adapter  => 'sqlite3', 
  :database => ':memory:'
}

ActiveRecord::Base.configurations['mssql'] = {
  :adapter  => 'sqlserver',
  :host     => 'localhost',
  :mode     => 'odbc', 
  :dsn      => 'activerecord_unittest',
  :database => 'activerecord_unittest',
  :username => 'rails',
  :password => nil
}

ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['sqlite'])

module SpecHelpers
  def self.included(base)
    base.extend ClassMethods
  end 
    
  module ClassMethods
    def connect_db(config)
      before(:all) do
        ActiveRecord::Base.connection.disconnect! rescue nil
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[config])      
        require 'resources/schema'
      end
    end
    
    def disconnect_db
      after(:all) do
        ActiveRecord::Base.connection.disconnect! rescue nil
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
