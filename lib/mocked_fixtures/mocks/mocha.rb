module MockedFixtures
  module Mocks
    module Mocha
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          alias_method_chain :stub, :attributes
        end
      end
      
      module InstanceMethods
        def stub_with_attributes(*args)
          return mock_without_attributes(*args) unless args.first < ActiveRecord::Base
          model_class = args.shift
          if options_and_stubs = args.first          
            all_attributes = options_and_stubs.delete(:all_attributes)
            add_errors     = options_and_stubs.delete(:add_errors)
            if all_attributes
              schema = MockedFixtures::SchemaParser.load_schema
              table  = model_class.table_name
              schema[table][:columns].each { |column| options_and_stubs[column[0].to_sym] = nil unless options_and_stubs.has_key?(column[0].to_sym) }
            end
            if add_errors
              errors = []
              errors.stubs(:count).returns(0)
              errors.stubs(:on).returns(nil)
              options_and_stubs.reverse_merge!(:errors => errors)
            end
          end
          stub_without_attributes("#{model_class}_#{options_and_stubs[:id]}", options_and_stubs)
        end
      end
    end
  end
end

Test::Unit::TestCase.send(:include, MockedFixtures::Mocks::Mocha)
