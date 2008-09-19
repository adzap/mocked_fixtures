module MockedFixtures
  class MockConnection
    attr_accessor :schema, :loaded_fixtures, :current_fixture_label

    # mock column class which is used in Fixtures class insert_fixtures method
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
      fixture.to_hash.inject({}) do |new_hash, (k, v)|
        begin
          type = @schema[table_name.to_s][:columns].assoc(k)[1]
          new_hash[k.to_sym] = type_cast_value(type, v)
          new_hash
        rescue
          raise "Mock fixture key '#{k}' not found in schema '#{table_name}'"
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
end
