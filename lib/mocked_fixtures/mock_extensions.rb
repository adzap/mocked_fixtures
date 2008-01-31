require 'active_record'
require 'active_record/fixtures'
module MockedFixtures
  module MockExtensions
    
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods
        alias_method_chain :mock_model, :attributes
      end
    end
    
    module ClassMethods      

    end
    
    module InstanceMethods
      def mock_model_with_attributes(model_class, options_and_stubs = {})
        attributes = options_and_stubs.delete(:attributes)
        object = mock_model_without_attributes(model_class, options_and_stubs)
        if attributes 
          schema = MockedFixtures::SchemaParser.load_schema
          table = model_class.table_name
          schema[table].each { |column| object.stub!(column.to_sym) }
        end
        object
      end
    end
  end 
  
end

class MockFixtures < Fixtures
    
  class DummyConnection
    cattr_accessor :schema
    self.schema = MockedFixtures::SchemaParser.load_schema
    
    # dummy column class which is used is Fixtures class
    # insert_fixtures method
    class Column 
      attr_accessor :name
    end
    
    def self.columns(table_name)
      schema[table_name.to_s].collect {|c| col = Column.new; col.name = c; col }
    end
    
    def self.insert_fixture(fixture, table_name)      
      # do nothing
    end
  end
  
  def self.create_fixtures(fixtures_directory, table_names, class_names = {})
    fixtures_map = {}
    table_names = [table_names].flatten.map { |n| n.to_s }
    fixtures = table_names.map do |table_name|
      fixtures_map[table_name] = MockFixtures.new(File.split(table_name.to_s).last, class_names[table_name.to_sym], File.join(fixtures_directory, table_name.to_s))
    end
    
    fixtures.each { |fixture| fixture.insert_fixtures }
  end
  
  def initialize(table_name, class_name, fixture_path, file_filter = DEFAULT_FILTER_RE)
    @table_name, @fixture_path, @file_filter = table_name, fixture_path, file_filter
    @class_name = class_name ||
                  (ActiveRecord::Base.pluralize_table_names ? @table_name.singularize.camelize : @table_name.camelize)
    @table_name = ActiveRecord::Base.table_name_prefix + @table_name + ActiveRecord::Base.table_name_suffix
    @table_name = class_name.table_name if class_name.respond_to?(:table_name)
    @connection = DummyConnection
    read_fixture_files
  end
  
  def column_names
    @column_names ||= @connection.columns(@table_name).collect(&:name)
  end
  
  def delete_existing_fixtures
    # override to do nothing
  end
end