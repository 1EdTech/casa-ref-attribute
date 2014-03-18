require 'casa/attribute/strategy/filter/string'

module CASA
  module Attribute
    module Strategy
      module Filter
        class StringSet < String

          private

          def process_blacklist payload

            attribute_from(payload).find_index(){ |attr| !passes_blacklist? attr }.nil?

          end

        end
      end
    end
  end
end