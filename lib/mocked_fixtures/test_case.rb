# Reloads test/unit to alias the method_added hook as its declared
# which doesn't seem to be possible after test/unit is loaded elsewhere.
#
# Many of these methods are renamed and modified form the Rails Fixtures 
# TestCase class extensions.
require 'test/unit'
module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      
      cattr_accessor :mock_fixture_table_names
      @@mock_fixture_table_names = []
      
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

        self.mock_fixture_table_names |= table_names
        
        #this is called as is from the Fixtures class
        require_fixture_classes(table_names)
        
        setup_mock_fixture_accessors(table_names)
      end      
      
      # Adds test case setup method to run  before each 
      # test to load fixture files and setup mock fixture 
      # accessors for test class. This runs before each 
      # test as the test class is recreated each time.       
      def self.method_added_with_mock_fixtures(method)
        return if @__disable_method_added__
        @__disable_method_added__ = true
        
        if method.to_s == 'setup'
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
     
      # This creates the fixture accessors and retrieves the
      # fixture and creates mock from it. Mocked fixture
      # is then cached.
      def self.setup_mock_fixture_accessors(table_names = nil)
        (table_names || mock_fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.', '_')
    
          define_method('mock_' + table_name) do |*fixtures|     
            @mock_fixture_cache[table_name] ||= {}
            mock_fixtures = self.class.loaded_mock_fixtures[table_name]
            instances = fixtures.map do |fixture|            
              if mock_fixtures[fixture.to_s]
                # get fixture and create a mock with it. Include all attributes in mock. Cache mock.
                @mock_fixture_cache[table_name][fixture] ||= 
                    mock_model(mock_fixtures.send(:model_class), 
                      {:all_attributes => true, :add_errors => true}.merge(mock_fixtures[fixture.to_s].to_hash.symbolize_keys)
                    )
              else
                raise StandardError, "No mocked fixture with name '#{fixture}' found for table '#{table_name}'"
              end
            end    
            instances.size == 1 ? instances.first : instances
          end
        end
      end
      
      # Loads fixtures to be mocked and stores them in 
      # class variable as they won't change.
      def load_mock_fixtures
        fixtures = MockFixtures.create_fixtures(fixture_path, self.class.mock_fixture_table_names, fixture_class_names)
        unless fixtures.nil?
          if fixtures.instance_of?(MockFixtures)            
            self.class.loaded_mock_fixtures[fixtures.table_name] = fixtures
          else
            fixtures.each { |f| self.class.loaded_mock_fixtures[f.table_name] = f }
          end
        end
      end
      
      # Mock fixture files are loaded once for all tests and specs
      def mock_fixture_setup 
        @mock_fixture_cache = {}
        return if self.class.mock_fixtures_loaded  
        load_mock_fixtures
        self.class.mock_fixtures_loaded = true
      end
    end
  end
end