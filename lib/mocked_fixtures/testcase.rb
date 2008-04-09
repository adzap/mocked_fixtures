# Many of these methods are renamed and modified form the Rails Fixtures
# TestCase class extensions.
require 'active_record/fixtures'
module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      
      superclass_delegating_accessor :mock_fixture_table_names
      self.mock_fixture_table_names = []
      
      cattr_accessor :loaded_mock_fixtures
      @@loaded_mock_fixtures = {}
      
      cattr_accessor :mock_fixtures_loaded
      @@mock_fixtures_loaded = false
      
      def self.mock_fixtures(*table_names)
        if table_names.first == :all
          table_names = Dir["#{fixture_path}/*.yml"] + Dir["#{fixture_path}/*.csv"]
          table_names.map! { |f| File.basename(f).split('.')[0..-2].join('.') }
        else
          table_names = table_names.flatten.map { |n| n.to_s }
        end

        self.mock_fixture_table_names = table_names
        
        #this is called as is from the Rails Fixtures class
        require_fixture_classes(table_names)
        
        setup_mock_fixture_accessors(table_names)
      end
      
       # Only load mock fixtures which are not already loaded
      def setup_with_mock_fixtures
        fixtures_to_load = self.class.mock_fixture_table_names - self.class.loaded_mock_fixtures.keys
        return if fixtures_to_load.empty?
        load_mock_fixtures(fixtures_to_load)
      end
      alias_method :setup, :setup_with_mock_fixtures
      
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
      # mock object from it. Mocked fixture is then cached.
      def self.setup_mock_fixture_accessors(table_names = nil)
        (table_names || mock_fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.', '_')
    
          define_method('mock_' + table_name) do |*fixtures|
            @mock_fixture_cache ||= {}
            @mock_fixture_cache[table_name] ||= {}
            if fixtures.first == :all
              fixtures = self.class.loaded_mock_fixtures[table_name].keys
            end
            
            instances = fixtures.map do |fixture|
              if self.class.loaded_mock_fixtures[table_name][fixture.to_s]
                # get fixture and create a mock with it. Include all attributes
                # in mock and the errors stub and mock object
                @mock_fixture_cache[table_name][fixture] ||= create_mock(table_name, fixture)
              else
                raise StandardError, "No mocked fixture with name '#{fixture}' found for table '#{table_name}'"
              end
            end
            instances.size == 1 ? instances.first : instances
          end
        end
      end
      
      # Create mock object from fixture
      def create_mock(table_name, fixture_name)
        table_fixtures = self.class.loaded_mock_fixtures[table_name]
        model_class    = table_fixtures.send(:model_class)
        columns        = table_fixtures.connection.schema[table_name]
        fixture        = table_fixtures[fixture_name.to_s]
        if defined?(Spec::Rails::Example::RailsExampleGroup) &&
            self.class < Spec::Rails::Example::RailsExampleGroup
          
          create_rspec_mock(model_class, fixture)
        else
          # other mocking libraries to support
        end
      end
      
      def create_rspec_mock(model_class, fixture)
        mock_model(model_class, { :all_attributes => true, :add_errors => true }.merge(fixture) )
      end
      
      # Loads fixtures to be mocked and stores them in class variable as they
      # won't change.
      def load_mock_fixtures(fixtures_to_load)
        fixtures = MockFixtures.create_fixtures(fixture_path, fixtures_to_load, fixture_class_names)
        unless fixtures.nil?
          fixtures.each { |f| self.class.loaded_mock_fixtures[f.table_name] = f }
        end
      end
    
    end
  end
end