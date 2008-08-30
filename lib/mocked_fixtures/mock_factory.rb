module MockedFixtures
  class MockFactory
    class << self
      
      # Create mock object from fixture
      def create_mock(type, model_class, fixture, testcase)
        testcase.send("mock_model_with_#{type}", model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end

    end
  end
end
