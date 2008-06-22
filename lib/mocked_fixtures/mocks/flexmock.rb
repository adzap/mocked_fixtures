module MockedFixtures
  module Mocks
    module Flexmock
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          alias_method_chain :flexmock, :attributes
        end
      end
      
      module InstanceMethods
        def flexmock_with_attributes(*args)
          return flexmock_without_attributes(*args) unless args.first == :model
          args.shift
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
              errors = flexmock_without_attributes(Array.new, :count => 0, :on => nil)
              options_and_stubs.reverse_merge!(:errors => errors)
            end
          end
          flexmock_without_attributes(:model, model_class, options_and_stubs)
        end
      end
    end
  end
end

Test::Unit::TestCase.send(:include, MockedFixtures::Mocks::Flexmock)
