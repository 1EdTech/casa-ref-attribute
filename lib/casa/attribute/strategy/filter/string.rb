require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Filter
        class String < ::CASA::Attribute::Strategy::Base

          def process payload

            return true unless attribute_in? payload

            if options.has_key? 'blacklist'
              process_blacklist payload
            else
              true
            end

          end

          private

          def process_blacklist payload

            passes_blacklist? attribute_from payload

          end

          def passes_blacklist? attr

            accept = true
            options['blacklist'].each do |match_string|
              if attr.match match_string_to_regex match_string
                accept = false
                break
              end
            end
            accept

          end

        end
      end
    end
  end
end