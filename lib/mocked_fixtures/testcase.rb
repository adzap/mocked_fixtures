# Many of these methods are renamed and modified from the Rails Fixtures
# TestCase class extensions.
module Test
  module Unit
    class TestCase
      
      superclass_delegating_accessor :mock_fixture_table_names      
      superclass_delegating_accessor :loaded_mock_fixtures
      superclass_delegating_accessor :mock_fixtures_loaded
      superclass_delegating_accessor :global_mock_fixtures
      superclass_delegating_accessor :mocked_fixtures_mock_framework

      self.mock_fixture_table_names = []
      self.loaded_mock_fixtures = {}
      self.mock_fixtures_loaded = false
     
      def self.global_mock_fixtures=(*table_names)
        table_names = self.all_fixture_table_names if table_names.first == :all
        self.mock_fixtures table_names.flatten.map { |n| n.to_s }
      end
      
      def self.mock_fixtures_with(mock_framework)
        require "mocked_fixtures/mocks/#{mock_framework}"
        self.mocked_fixtures_mock_framework = mock_framework
        unless mock_framework == :rspec
          self.send(:alias_method, :mock_model, "mock_model_with_#{mock_framework}".to_sym) 
        end
      end
      
      def self.mock_fixtures(*table_names)
        table_names = self.all_fixture_table_names if table_names.first == :all

        table_names = table_names.flatten.map { |n| n.to_s }

        self.mock_fixture_table_names |= table_names
        
        require_fixture_classes(table_names)
        setup_mock_fixture_accessors(table_names)
      end
      
      def self.all_fixture_table_names
        table_names = Dir["#{fixture_path}/*.yml"] + Dir["#{fixture_path}/*.csv"]
        table_names.map { |f| File.basename(f).split('.')[0..-2].join('.') }
      end
      
      # Adds test case setup method to run before each test to load fixture
      # files and setup mock fixture accessors for test class. This runs before
      # each test as the test class is recreated each time.
      def self.method_added_with_mock_fixtures(method)
        return if @__disable_method_added__
        @__disable_method_added__ = true

        if method.to_s == 'setup'
          unless method_defined?(:setup_without_mock_fixtures)
            alias_method :setup_without_mock_fixtures, :setup
            define_method(:mock_fixture_setup) do
              setup_with_mock_fixtures
              setup_without_mock_fixtures
            end
          end
          alias_method :setup, :mock_fixture_setup
        end
        
        @__disable_method_added__ = false
        method_added_without_mock_fixtures(method)
      end
     
      class << self
        alias_method_chain :method_added, :mock_fixtures        
      end
     
      # This creates the fixture accessors and retrieves the fixture and creates
      # mock object from it. Mock fixture is then cached.
      def self.setup_mock_fixture_accessors(table_names = nil)
        (table_names || mock_fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.', '_')
    
          define_method('mock_' + table_name) do |*fixtures|
            @mock_fixture_cache ||= {}
            @mock_fixture_cache[table_name] ||= {}
            if fixtures.first == :all
              fixtures = self.class.loaded_mock_fixtures[table_name].keys
            end           
            
            mock_type = self.class.mocked_fixtures_mock_framework
            
            instances = fixtures.map do |fixture_name|
              if fixture = self.class.loaded_mock_fixtures[table_name][fixture_name.to_s]
                unless model_class = self.class.loaded_mock_fixtures[table_name].send(:model_class)
                  raise StandardError, "No model class found for table name '#{table_name}'. Specify it explicitly 'set_fixture_class :table_name => 'ClassName'."
                end
                
                @mock_fixture_cache[table_name][fixture_name] ||= MockedFixtures::MockFactory.create_mock(mock_type, model_class, fixture, self)
              else
                raise StandardError, "No mock fixture with name '#{fixture}' found for table '#{table_name}'"
              end
            end

            instances.size == 1 ? instances.first : instances
          end
          
        end
      end
      
      def setup_with_mock_fixtures
        fixtures_to_load = self.class.mock_fixture_table_names - self.class.loaded_mock_fixtures.keys
        return if fixtures_to_load.empty?
        load_mock_fixtures(fixtures_to_load)
      end
      alias_method :setup, :setup_with_mock_fixtures

      # Loads fixtures to be mocked and cache them in class variable
      def load_mock_fixtures(fixtures_to_load)
        fixtures = MockedFixtures::MockFixtures.create_fixtures(fixture_path, fixtures_to_load, fixture_class_names)
        unless fixtures.nil?
          fixtures.each { |f| self.class.loaded_mock_fixtures[f.table_name] = f }
        end
      end
    
    end
  end
end
