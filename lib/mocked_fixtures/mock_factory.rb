module MockedFixtures
  class MockFactory
    class << self
      
      # Create mock object from fixture
      def create_mock(type, model_class, fixture, testcase)
        self.send("create_#{type}_mock", model_class, fixture, testcase)
      end
      
      def create_rspec_mock(model_class, fixture, testcase)
        testcase.mock_model(model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end
      
      def create_flexmock_mock(model_class, fixture, testcase)
        testcase.flexmock(:model, model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end
      
      def create_mocha_mock(model_class, fixture, testcase)
        testcase.stub(model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end      
    end
  end
end
