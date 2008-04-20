# rspec_on_rails mock_model extensions to add the stubs
# for all attributes and the errors method
module MockedFixtures
  module MockExtensions
    
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        alias_method_chain :mock_model, :attributes
      end
    end
    
    module InstanceMethods
      def mock_model_with_attributes(model_class, options_and_stubs = {})
        attributes = options_and_stubs.delete(:all_attributes)
        errors     = options_and_stubs.delete(:add_errors)
        object     = mock_model_without_attributes(model_class, options_and_stubs)
        if attributes
          schema = MockedFixtures::SchemaParser.load_schema
          table  = model_class.table_name
          schema[table][:columns].each { |column| object.stub!(column[0].to_sym) unless object.respond_to?(column[0]) }
        end
        if errors
          errors = []
          errors.stub!(:count).and_return(0)
          errors.stub!(:on).and_return(nil)
          object.stub!(:errors).and_return(errors)
        end
        object
      end
    end
  end
end