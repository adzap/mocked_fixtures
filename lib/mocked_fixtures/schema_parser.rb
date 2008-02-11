module MockedFixtures
  class SchemaParser
    def self.schema_path
      RAILS_ROOT + '/db/schema.rb'
    end
    
    # Parses schema.rb file and pulls out all the columns names and types into 
    # an array, with each row being an array of the column name and type
    # respectively.
    def self.load_schema(path=nil)
      schema = {}
      table_name = ""
      open(path || schema_path, 'r').each do |line|  
        if /create_table "(\w+)".*? do \|t\|/ =~ line
          table_name = $1
          schema[table_name] = ($& =~ /(:id => false)/) ? [] : [['id', 'integer']]
          next
        elsif /t\.(\w+)\s+"(\w+)"/ =~ line
          schema[table_name] << [$2, $1]
        end
      end
      schema
    end
  end  
end