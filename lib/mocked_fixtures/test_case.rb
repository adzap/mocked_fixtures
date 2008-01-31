require 'test/unit'
module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      
      # FIXME: can't use cattr for these accessors as rails is not loaded yet
      # how to load this file after rails loads but before test/unit
      @@mock_fixture_table_names = []
      def self.mock_fixture_table_names
        @@mock_fixture_table_names
      end
      
      def self.mock_fixture_table_names=(value)
        @@mock_fixture_table_names = value
      end
            
      @@all_loaded_mock_fixtures = {}
      def self.all_loaded_mock_fixtures
        @@all_loaded_mock_fixtures
      end 
      
      @@mock_fixtures_loaded = false
      def self.mock_fixtures_loaded
        @@mock_fixtures_loaded
      end
      
      def self.mock_fixtures_loaded=(value)
        @@mock_fixtures_loaded = value
      end      
      
      # modified from Fixtures TestCase extensions
      def self.mock_fixtures(*table_names)
        if table_names.first == :all
          table_names = Dir["#{fixture_path}/*.yml"] + Dir["#{fixture_path}/*.csv"]
          table_names.map! { |f| File.basename(f).split('.')[0..-2].join('.') }
        else
          table_names = table_names.flatten.map { |n| n.to_s }
        end

        self.mock_fixture_table_names |= table_names
        require_fixture_classes(table_names)
        setup_mock_fixture_accessors(table_names)
      end      
    
      def self.method_added_with_mock_fixtures(method)
        return if @__disable_method_added__
        @__disable_method_added__ = true
        
        if method.to_s == 'setup'
          unless method_defined?(:setup_with_mock_fixtures)
            define_method(:setup_with_mock_fixtures) do
              mock_fixture_setup
              setup_without_mock_fixtures
            end
            alias_method :setup_without_mock_fixtures, :setup
            alias_method :setup, :setup_with_mock_fixtures 
          end          
        end
        
        @__disable_method_added__ = false
        method_added_without_mock_fixtures(method)
      end
      
      class << self
        alias_method :method_added_without_mock_fixtures, :method_added 
        alias_method :method_added, :method_added_with_mock_fixtures
      end      
     
      # modified from Fixtures TestCase extensions
      def self.setup_mock_fixture_accessors(table_names = nil)
        (table_names || mock_fixture_table_names).each do |table_name|
          table_name = table_name.to_s.tr('.', '_')
    
          define_method('mock_' + table_name) do |*fixtures|     
            @mock_fixture_cache[table_name] ||= {}
    
            instances = fixtures.map do |fixture|            
              if self.class.all_loaded_mock_fixtures[table_name][fixture.to_s]
                @mock_fixture_cache[table_name][fixture] ||= mock_model(self.class.all_loaded_mock_fixtures[table_name].send(:model_class), self.class.all_loaded_mock_fixtures[table_name][fixture.to_s].to_hash)
              else
                raise StandardError, "No fixture with name '#{fixture}' found for table '#{table_name}'"
              end
            end
    
            instances.size == 1 ? instances.first : instances
          end
        end
      end
      
      def load_mock_fixtures
        fixtures = MockFixtures.create_fixtures(fixture_path, self.class.mock_fixture_table_names, fixture_class_names)
        unless fixtures.nil?
          if fixtures.instance_of?(MockFixtures)
            puts 'fixtures loaded'
            self.class.loaded_mock_fixtures[fixtures.table_name] = fixtures
          else
            fixtures.each { |f| self.class.all_loaded_mock_fixtures[f.table_name] = f }
          end
        end      
      end
      
      def mock_fixture_setup 
        @mock_fixture_cache = {}
        return self.class.mock_fixtures_loaded
#        return if @mock_fixtures_setup
        @mock_fixtures_setup = true        
        load_mock_fixtures
        self.class.mock_fixtures_loaded = true
      end
    end
  end
end