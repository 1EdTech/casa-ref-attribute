require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Transform
        class Object < ::CASA::Attribute::Strategy::Base

          def process payload

            retval = nil

            unless retval
              retval = by_replacement_for payload if @options.has_key? 'replace'
            end

            unless retval
              retval = current_value_for payload
            end

            retval

          end

          def by_replacement_for payload

            payload_key = "#{payload['identity']['id']}@#{payload['identity']['originator_id']}"

            if @options['replace'].has_key? payload_key
              @options['replace'][payload_key]
            else
              nil
            end

          end

          def current_value_for payload

            attribute_in?(payload) ? payload['attributes'][definition.section][definition.name] : nil

          end

        end
      end
    end
  end
end