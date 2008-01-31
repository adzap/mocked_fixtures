module MockedFixtures
  module MockExtensions
    
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods
        alias_method_chain :mock_model, :attributes
      end
    end
    
    module ClassMethods      

    end
    
    # rspec_on_rails extensions to add the stubs for the attributes
    # and the errors method 
    module InstanceMethods
      def mock_model_with_attributes(model_class, options_and_stubs = {})
        attributes = options_and_stubs.delete(:attributes)
        errors     = options_and_stubs.delete(:errors)
        object = mock_model_without_attributes(model_class, options_and_stubs)
        if attributes 
          schema = MockedFixtures::SchemaParser.load_schema
          table = model_class.table_name
          schema[table].each { |column| object.stub!(column.to_sym) }
        end
        if errors
          errors = []
          errors.stub!(:count).and_return(0)
          errors.stub!(:on).and_return([])
          object.stub!(:errors).and_return(errors)
        end
        object
      end
    end
  end 
end