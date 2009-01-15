module MockedFixtures
  module Spec
    module Configuration
      def global_mock_fixtures
        Test::Unit::TestCase.mock_fixture_table_names
      end
      
      def global_mock_fixtures=(fixtures)
        Test::Unit::TestCase.mock_fixtures(*fixtures)
      end
      
      def mock_fixtures_with(mock_framework)
        Test::Unit::TestCase.mock_fixtures_with mock_framework
      end
    end
  end
end

if defined?(Spec::Example::Configuration)
  Spec::Example::Configuration
else
  Spec::Runner::Configuration
end.send(:include, MockedFixtures::Spec::Configuration)
