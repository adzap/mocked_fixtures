module MockedFixtures
  class MockFixtures < Fixtures
    attr_reader :connection
    
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
      @connection = MockedFixtures::MockConnection.new
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
