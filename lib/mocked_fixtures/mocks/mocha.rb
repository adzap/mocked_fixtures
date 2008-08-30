require 'mocha'
module MockedFixtures
  module Mocks
    module Mocha
    
      def mock_model_with_mocha(model_class, options_and_stubs={})
        all_attributes = options_and_stubs.delete(:all_attributes)
        add_errors     = options_and_stubs.delete(:add_errors)
        if all_attributes
          schema = MockedFixtures::SchemaParser.load_schema
          table  = model_class.table_name
          schema[table][:columns].each { |column| options_and_stubs[column[0].to_sym] = nil unless options_and_stubs.has_key?(column[0].to_sym) }
        end
        if add_errors
          errors = []
          errors.stubs(:count).returns(0)
          errors.stubs(:on).returns(nil)
          options_and_stubs.reverse_merge!(:errors => errors)
        end
        options_and_stubs.reverse_merge!(
          :id => options_and_stubs[:id],
          :to_param => options_and_stubs[:id].to_s,
          :new_record? => false
        )
        obj = stub("#{model_class}_#{options_and_stubs[:id]}", options_and_stubs)
        obj.instance_eval <<-CODE
          def is_a?(other)
            #{model_class}.ancestors.include?(other)
          end
          def kind_of?(other)
            #{model_class}.ancestors.include?(other)
          end
          def instance_of?(other)
            other == #{model_class}
          end
          def class
            #{model_class}
          end
        CODE
        obj
      end

    end
  end
end

Test::Unit::TestCase.send(:include, MockedFixtures::Mocks::Mocha)
