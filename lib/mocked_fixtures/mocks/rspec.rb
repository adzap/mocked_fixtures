# rspec-rails mock_model extensions to add the stubs
# for all attributes and the errors method
module MockedFixtures
  module Mocks
    module Rspec
    
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          alias_method_chain :mock_model, :attributes
          alias_method :mock_model_with_rspec, :mock_model_with_attributes
        end
      end
      
      module InstanceMethods
        def mock_model_with_attributes(model_class, options_and_stubs = {})
          if options_and_stubs.delete(:all_attributes)
            schema = MockedFixtures::SchemaParser.load_schema
            table  = model_class.table_name
            schema[table][:columns].each { |column| options_and_stubs[column[0].to_sym] = nil unless options_and_stubs.has_key?(column[0].to_sym) }
          end
          if options_and_stubs.delete(:add_errors)
            errors = []
            errors.stub!(:count).and_return(0)
            errors.stub!(:on).and_return(nil)
            options_and_stubs.reverse_merge!(:errors => errors)
          end
          mock_model_without_attributes(model_class, options_and_stubs)
        end
      end
      
    end
  end
end

Spec::Rails::Example::RailsExampleGroup.send(:include, MockedFixtures::Mocks::Rspec)
