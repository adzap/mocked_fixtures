# This adds the method to find the primary key for the schema dumper so that
# the schema will correctly define the primary key
module MockedFixtures
  module ConnectionAdapters
    module SQLServerAdapter
      
      # Returns a table's primary key and belonging sequence (not applicable to SQL server).
      def pk_and_sequence_for(table_name)
        @connection["AutoCommit"] = false
        keys = []
        execute("EXEC sp_helpindex '#{table_name}'") do |handle|
          if handle.column_info.any?
            pk_index = handle.detect {|index| index[1] =~ /primary key/ }
            keys << pk_index[2] if pk_index
          end
        end
        keys.length == 1 ? [keys.first, nil] : nil
      ensure
        @connection["AutoCommit"] = true
      end
      
    end
  end
end