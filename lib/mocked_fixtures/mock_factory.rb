module MockedFixtures
  class MockFactory
    class << self
      
      # Create mock object from fixture
      def create_mock(type, model_class, fixture, testcase)
        unless type
          if testcase.respond_to?(:mock_model)
            type = :rspec
          elsif testcase.respond_to?(:flexmock)
            type = :flexmock
          elsif testcase.respond_to?(:mocha)
            type = :mocha
          end
        end
        self.send("create_#{type}_mock", model_class, fixture, testcase)
      end
      
      def create_rspec_mock(model_class, fixture, testcase)
        testcase.mock_model(model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end
      
      def create_flexmock_mock(model_class, fixture, testcase)
        testcase.flexmock(:model, model_class, { :all_attributes => true})
      end
      
    end
  end
end
