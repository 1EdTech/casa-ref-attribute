require 'casa/attribute/strategy/squash/object'

module CASA
  module Attribute
    module Strategy
      module Squash
        class Immutable < Object

          def process payload

            use_original_from payload

          end

        end
      end
    end
  end
end