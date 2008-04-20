if defined?(ActiveRecord::ConnectionAdapters::SQLServerAdapter) && 
    !ActiveRecord::ConnectionAdapters::SQLServerAdapter.methods.include?(:pk_and_sequence_for)
  require "mocked_fixtures/connection_adapters/sqlserver_adapter"
end
