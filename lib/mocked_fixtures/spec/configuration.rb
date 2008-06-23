module MockedFixtures
  module Spec
    module Configuration
      def global_mock_fixtures
        Test::Unit::TestCase.mock_fixture_table_names
      end
      
      def global_mock_fixtures=(fixtures)
        Test::Unit::TestCase.mock_fixtures(*fixtures)
      end
      
      def mocked_fixtures_mock_with=(mock_framework)
        Test::Unit::TestCase.mocked_fixtures_mock_with = mock_framework
      end
    end
  end
end

Spec::Example::Configuration.send(:include, MockedFixtures::Spec::Configuration)
