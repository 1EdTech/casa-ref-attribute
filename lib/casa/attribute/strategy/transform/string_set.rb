require 'casa/attribute/strategy/transform/string'

module CASA
  module Attribute
    module Strategy
      module Transform
        class StringSet < String

          def by_substitution_for payload

            return nil unless attribute_in? payload

            # precompute substitution regexes
            substitution_regexes = {}
            @options['substitute'].each do |match_string, replacement|
              substitution_regexes[match_string_to_regex(match_string)] = replacement
            end

            attribute_from(payload).map(){ |item|
              substitution_regexes.each do |substitution_regex, replacement|
                if replacement
                  item.gsub! substitution_regex, replacement
                elsif item.match substitution_regex
                  return nil
                end
              end
              item
            }.select(){ |item| !item.nil? }

          end

        end
      end
    end
  end
end