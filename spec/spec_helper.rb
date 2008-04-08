$: << File.dirname(__FILE__) + '/../lib' << File.dirname(__FILE__) + '/rspec_on_rails' << File.dirname(__FILE__)

require 'rubygems'
require 'spec'
require 'activerecord'
require 'activesupport'

require 'mocked_fixtures'

#require 'rspec_on_rails/testcase'
#require 'rspec_on_rails/rails_example_group'

#Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::MockExtensions)