module MockedFixtures
  class MockFixtures < Fixtures
    attr_reader :connection
    
    class DummyConnection
      attr_accessor :schema, :loaded_fixtures, :current_fixture_label
      
      # dummy column class which is used in Fixtures class insert_fixtures method
      class Column
        attr_accessor :name, :type
        def initialize(name, type)
          @name, @type = name, type
        end
      end
      
      def initialize
        @schema  = @@schema ||= MockedFixtures::SchemaParser.load_schema
        @columns = {}
        @loaded_fixtures = {}
      end
       
      # stores full fixture after association values loaded and type casting
      def insert_fixture(fixture, table_name)
        loaded_fixtures[table_name] ||= {}
        loaded_fixtures[table_name][@current_fixture_label] = type_cast_fixture(fixture, table_name)
      end
      
      def type_cast_fixture(fixture, table_name)
        fixture.to_hash.inject({}) do |new_hash, row|
          begin
            type = @schema[table_name.to_s][:columns].assoc(row[0])[1]
            new_hash[row[0].to_sym] = type_cast_value(type, row[1])
            new_hash
          rescue
            raise "Mock fixture key '#{row[0]}' not found in schema '#{table_name}'"
          end
        end
      end
      
      # Modified from ActiveRecord::Column class.
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
      
      def columns(table_name)
        @columns[table_name] ||= @schema[table_name.to_s][:columns].collect {|c| Column.new(c[0], c[1]) }
      end
    end
    
    # Gets loaded fixture files for each table and type casts the values and
    # returns the array of MockFixtures instances. The insert_fixtures method
    # is in the superclass and does all the foxy fixtures work.
    def self.create_fixtures(fixtures_directory, table_names, class_names = {})
      table_names = Array(table_names).flatten.map { |n| n.to_s }
      fixtures = table_names.map do |table_name|
        fixture = MockedFixtures::MockFixtures.new(File.split(table_name.to_s).last, class_names[table_name.to_sym], File.join(fixtures_directory, table_name.to_s))
        fixture.insert_fixtures
        fixture.each {|label, f| fixture[label] = fixture.connection.loaded_fixtures[fixture.table_name][label] }
      end
    end
    
    def initialize(table_name, class_name, fixture_path, file_filter = DEFAULT_FILTER_RE)
      @table_name, @fixture_path, @file_filter = table_name, fixture_path, file_filter
      @class_name = class_name || (ActiveRecord::Base.pluralize_table_names ? @table_name.singularize.camelize : @table_name.camelize)
      @table_name = ActiveRecord::Base.table_name_prefix + @table_name + ActiveRecord::Base.table_name_suffix
      @table_name = class_name.table_name if class_name.respond_to?(:table_name)
      @connection = DummyConnection.new
      read_fixture_files
    end
    
    # overrides method to prevent database hit 
    def has_primary_key_column?
      @has_primary_key_column ||= !primary_key_name.nil?
    end  
    
    # overrides method to prevent database hit and uses dummy connection
    # which gets primary key from schema.rb
    def primary_key_name
      @primary_key_name ||= @connection.schema[@table_name.to_s][:primary_key]
    end  
    
    def column_names
      @column_name ||= @connection.columns(@table_name).collect(&:name)
    end
    
    def delete_existing_fixtures
      # override to do nothing (NOP) as we are not using the database, so nothing needs deleting
    end  
    
    # The each method is aliased to allow the fixture label to be captured during 
    # iteration in superclass methods, particularly the insert_fixtures method. 
    # The label is required for the insert_fixture connection method to be able 
    # store the final fixture hash and reference it by its label for later.
    alias :original_each :each  
    def each
      original_each do |label, fixture|
        connection.current_fixture_label = label
        yield label, fixture
        connection.current_fixture_label = nil
      end    
    end
  end
end
