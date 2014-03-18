require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Filter
        class Boolean < ::CASA::Attribute::Strategy::Base

          def process payload

            if options.has_key? 'value'

              attr = attribute_from payload
              value = options['value']
              optional = options['optional'] if options.has_key?('optional')

              attr.nil? ? optional : attr == value

            else

              true

            end

          end

        end
      end
    end
  end
end