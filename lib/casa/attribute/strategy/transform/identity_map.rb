require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Transform
        class IdentityMap < ::CASA::Attribute::Strategy::Base

          def key payload
            "#{payload['identity']['id']}@#{payload['identity']['originator_id']}"
          end

          def process payload
            payload_key = key payload

            if @options.has_key? payload_key
              @options[payload_key]
            else
              attributes = payload['attributes']
              if attributes.has_key?(definition.section) and attributes[definition.section].has_key?(definition.name)
                attributes[definition.section][definition.name]
              else
                nil
              end
            end
          end

        end
      end
    end
  end
end