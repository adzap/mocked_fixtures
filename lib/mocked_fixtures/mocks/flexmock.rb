module MockedFixtures
  module Mocks
    module Flexmock
    
      def mock_model_with_flexmock(model_class, options_and_stubs={})
        all_attributes = options_and_stubs.delete(:all_attributes)
        add_errors     = options_and_stubs.delete(:add_errors)

        if all_attributes
          schema = MockedFixtures::SchemaParser.load_schema
          table  = model_class.table_name
          schema[table][:columns].each { |column| options_and_stubs[column[0].to_sym] = nil unless options_and_stubs.has_key?(column[0].to_sym) }
        end
        if add_errors
          errors = flexmock(Array.new, :count => 0, :on => nil)
          options_and_stubs.reverse_merge!(:errors => errors)
        end
        options_and_stubs.reverse_merge!({        
          :id => id,
          :to_param => id.to_s,
        })
        flexmock(:model, model_class, options_and_stubs)
      end
      
    end
  end
end

Test::Unit::TestCase.send(:include, MockedFixtures::Mocks::Flexmock)
