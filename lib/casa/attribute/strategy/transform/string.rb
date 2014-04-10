require 'casa/attribute/strategy/transform/object'

module CASA
  module Attribute
    module Strategy
      module Transform
        class String < Object

          def process payload

            retval = nil

            unless retval
              retval = by_replacement_for payload if options.has_key? 'replace'
            end

            unless retval
              retval = by_substitution_for payload if options.has_key? 'substitute'
            end

            unless retval
              retval = current_value_for payload
            end

            retval

          end

          def by_substitution_for payload

            return nil unless attribute_in? payload

            attr = attribute_from payload

            options['substitute'].each do |match_string, replacement|
              attr.gsub! match_string_to_regex(match_string), replacement
            end

            attr

          end

        end
      end
    end
  end
end