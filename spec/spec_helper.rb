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

ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['sqlite'])

module SpecHelpers
  def connect_db(config='sqlite')
    ActiveRecord::Base.connection.disconnect! rescue nil
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[config])
    require 'resources/schema'
  end

  def disconnect_db
    ActiveRecord::Base.connection.disconnect! rescue nil
  end
end

Spec::Runner.configure do |config|
  config.include SpecHelpers
end
