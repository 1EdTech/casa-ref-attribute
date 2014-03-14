require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Transform
        class String < ::CASA::Attribute::Strategy::Base

          def process payload

            retval = nil

            unless retval
              retval = by_replacement_for payload if @options.has_key? 'replace'
            end

            unless retval
              retval = by_substitution_for payload if @options.has_key? 'substitute'
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

          def by_substitution_for payload

            attr = attribute_from payload

            @options['substitute'].each do |match_string, replacement|
              attr.gsub! match_string_to_regex(match_string), replacement
            end

            attr

          end

          def current_value_for payload

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