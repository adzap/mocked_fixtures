module MockedFixtures
  class SchemaParser
    def self.schema_path
      RAILS_ROOT + '/db/schema.rb'
    end
    
    # Parses schema.rb file and pulls out all the columns names.
    def self.load_schema(path=nil)
      schema = {}
      table_name = ""
      open(path || schema_path, 'r').each do |line|  
        if /create_table "(\w+)".*? do \|t\|/ =~ line
          table_name = $1
          schema[table_name] = []
          next
        elsif /t\.\w+\s+"(\w+)"/ =~ line
          schema[table_name] << $1
        end
      end
      schema
    end
  end  
end