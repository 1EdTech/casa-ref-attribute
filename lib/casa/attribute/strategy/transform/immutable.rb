require 'casa/attribute/strategy/transform/object'

module CASA
  module Attribute
    module Strategy
      module Transform
        class Immutable < Object

          def process payload

            return nil unless attribute_in? payload

            current_value_for payload

          end

        end
      end
    end
  end
end