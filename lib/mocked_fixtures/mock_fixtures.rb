require 'active_record/fixtures'
class MockFixtures < Fixtures
    
  class DummyConnection
    cattr_accessor :schema
    
    # dummy column class which is used is Fixtures class
    # insert_fixtures method
    class Column 
      attr_accessor :name, :type
      def initialize(name, type)
        @name, @type = name, type
      end
    end
    
    def self.schema(path=nil)
      @@schema ||= MockedFixtures::SchemaParser.load_schema(path)
    end
    
    def self.columns(table_name)
      @@columns ||= schema[table_name.to_s].collect {|c| col = Column.new(c[0], c[1]) }
    end
 
    def schema
      self.class.schema
    end
    
    def columns(table_name)
      self.class.columns(table_name)
    end
    
    def insert_fixture(fixture, table_name) 
      # override to do nothing (NOP) as we are not using the database
    end
    
    def type_cast_fixture(fixture, table_name)      
      fixture.to_hash.inject({}) do |new_hash, row|
        begin
          type = schema[table_name.to_s].assoc(row[0])[1]
          new_hash[row[0].to_sym] = type_cast_value(type, row[1])
          new_hash
        rescue
          raise "Mock fixture key '#{row[0]}' not found in schema '#{table_name}'"
        end
      end
    end
    
    # Modified from ActiveRecord::Column class. Some columns make fail with
    # certains adapters, such as the boolean.
    # TODO: use native test schema adapter for type casting
    def type_cast_value(type, value)
      return nil if value.nil?
      column = ActiveRecord::ConnectionAdapters::Column
      case type.to_sym
        when :string    then value
        when :text      then value
        when :integer   then value.to_i rescue value ? 1 : 0
        when :float     then value.to_f
        when :decimal   then column.value_to_decimal(value)
        when :datetime  then column.string_to_time(value)
        when :timestamp then column.string_to_time(value)
        when :time      then column.string_to_dummy_time(value)
        when :date      then column.string_to_date(value)
        when :binary    then column.binary_to_string(value)
        when :boolean   then column.value_to_boolean(value)
        else value
      end
    end
  end
  
  # Gets loaded fixture files for each table and type casts the values and 
  # returns the array of MockFixtures instances. The insert_fixtures method
  # is necessary to get the superclass to do all the fancy associations work
  def self.create_fixtures(fixtures_directory, table_names, class_names = {})
    table_names = [table_names].flatten.map { |n| n.to_s }
    fixtures = table_names.map do |table_name|      
      fixture = MockFixtures.new(File.split(table_name.to_s).last, class_names[table_name.to_sym], File.join(fixtures_directory, table_name.to_s))
      fixture.insert_fixtures
      fixture.each {|label, f| fixture[label] = fixture.connection.type_cast_fixture(f, fixture.table_name) }
    end
  end
  
  attr_reader :connection
  
  def initialize(table_name, class_name, fixture_path, file_filter = DEFAULT_FILTER_RE)
    @table_name, @fixture_path, @file_filter = table_name, fixture_path, file_filter
    @class_name = class_name ||
                  (ActiveRecord::Base.pluralize_table_names ? @table_name.singularize.camelize : @table_name.camelize)
    @table_name = ActiveRecord::Base.table_name_prefix + @table_name + ActiveRecord::Base.table_name_suffix
    @table_name = class_name.table_name if class_name.respond_to?(:table_name)
    @connection = DummyConnection.new
    read_fixture_files
  end
  
  def column_names
    @column_name ||= @connection.columns(@table_name).collect(&:name)
  end
  
  def delete_existing_fixtures
    # override to do nothing (NOP) as we are not using the database
  end
end