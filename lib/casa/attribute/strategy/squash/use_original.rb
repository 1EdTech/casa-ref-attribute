require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Squash
        class UseOriginal < CASA::Attribute::Strategy::Base

          def process payload

            if payload['original'].has_key?(section) and payload['original'][section].has_key?(name)
              payload['original'][section][name]
            else
              nil
            end

          end

        end
      end
    end
  end
end