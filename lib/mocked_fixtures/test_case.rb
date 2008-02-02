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

        # stores table_names for subclass only
        self.mock_fixture_table_names = table_names
        
        #this is called as is from the Fixtures class
        require_fixture_classes(table_names)
        
        setup_mock_fixture_accessors(table_names)
      end      
      
      # Adds test case setup method to run  before each test to load fixture 
      # files and setup mock fixture accessors for test class. This runs before
      # each test as the test class is recreated each time.       
      def self.method_added_with_mock_fixtures(method)
        return if @__disable_method_added__
        @__disable_method_added__ = true

        if method.to_s == 'setup'
          puts 'loaded'
          unless method_defined?(:setup_with_mock_fixtures)
            define_method(:setup_with_mock_fixtures) do
              mock_fixture_setup
              setup_without_mock_fixtures
            end
            alias_method_chain :setup, :mock_fixtures
          end          
        end
        
        @__disable_method_added__ = false
        method_added_without_mock_fixtures(method)
      end
      
      class << self
        alias_method_chain :method_added, :mock_fixtures
      end      
     
      # This creates the fixture accessors and retrieves the fixture and creates
      # mock from it. Mocked fixture is then cached.
      def self.setup_mock_fixture_accessors(table_names = nil)
        (table_names || mock_fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.', '_')
    
          define_method('mock_' + table_name) do |*fixtures|
            @mock_fixture_cache ||= {}
            @mock_fixture_cache[table_name] ||= {}
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
      
      def create_mock(table_name, fixture)
        table_fixtures = self.class.loaded_mock_fixtures[table_name]
        model_class    = table_fixtures.send(:model_class)
        attributes     = table_fixtures.connection.schema[table_name]
        fixture        = table_fixtures[fixture.to_s].to_hash.symbolize_keys
        
        if defined?(Spec::Rails::Example::RailsExampleGroup) && 
            self.class < Spec::Rails::Example::RailsExampleGroup
          
          create_rspec_mock(model_class, fixture)
        else
          create_rspec_mock(model_class, fixture)
        end
        
      end     
      
      def create_rspec_mock(model_class, fixture)
        mock_model(model_class,
                    { :all_attributes => true, 
                      :add_errors     => true
                    }.merge(fixture) )
      end
      
      # Loads fixtures to be mocked and stores them in class variable as they
      # won't change.
      def load_mock_fixtures(fixtures_to_load)
        fixtures = MockFixtures.create_fixtures(fixture_path, fixtures_to_load, fixture_class_names)
        unless fixtures.nil?
          if fixtures.instance_of?(MockFixtures)            
            self.class.loaded_mock_fixtures[fixtures.table_name] = fixtures
          else
            fixtures.each { |f| self.class.loaded_mock_fixtures[f.table_name] = f }
          end
        end
      end
      
      # Only load mock fixtures which are not already loaded
      def mock_fixture_setup    
        fixtures_to_load = self.class.mock_fixture_table_names - self.class.loaded_mock_fixtures.keys
        return if fixtures_to_load.empty?       
        load_mock_fixtures(fixtures_to_load)
      end
    end
  end
end