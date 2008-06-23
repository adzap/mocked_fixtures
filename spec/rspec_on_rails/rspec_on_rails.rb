module Spec
  module Rails
    module Matchers; end
  end
end

module ActionView
  class Base
    def self.cache_template_extensions=(arg)
    end
  end
end

require 'rspec_on_rails/mocks'
require 'rspec_on_rails/rails_example_group'
