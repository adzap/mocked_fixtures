module MockedFixtures
  class SchemaParser
    cattr_accessor :schema_path
    
    # Parses schema.rb file and pulls out all the columns names and types into
    # an array, with each row being an array of the column name and type
    # respectively.
    def self.load_schema
      schema = {}
      table_name = ""
      open(schema_path, 'r').each do |line|
        if /create_table "(\w+)".*? do \|t\|/ =~ line
          table_name = $1
          schema[table_name] = {:columns => [], :primary_key => nil}
          schema[table_name][:columns] 
          if line =~ /:primary_key => "(.*?)"/
            schema[table_name][:columns] << [$1, 'integer']
            schema[table_name][:primary_key] = $1
          elsif line !~ /:id => false/
            schema[table_name][:columns] << ['id', 'integer']
            schema[table_name][:primary_key] = 'id'
          end
        elsif /t\.(\w+)\s+"(\w+)"/ =~ line
          schema[table_name][:columns] << [$2, $1]
        end
      end
      schema
    end
  end
end