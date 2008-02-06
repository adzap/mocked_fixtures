require 'active_record/fixtures'
class MockFixtures < Fixtures
    
  class DummyConnection
    cattr_accessor :schema
    
    # dummy column class which is used is Fixtures class
    # insert_fixtures method
    class Column 
      attr_accessor :name
      def initialize(name)      
        self.name = name
      end
    end
    
    def self.schema(path=nil)
      @@schema ||= MockedFixtures::SchemaParser.load_schema(path)
    end
    
    def self.columns(table_name)
      schema[table_name.to_s].collect {|c| col = Column.new(c) }
    end
    
    def self.insert_fixture(fixture, table_name)      
      # override to do nothing (NOP) as we are no using the database
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
  
  attr_reader :connection
  
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
    @column_name ||= @connection.columns(@table_name).collect(&:name)
  end
  
  def delete_existing_fixtures
    # override to do nothing (NOP) as we are no using the database
  end
end