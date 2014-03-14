require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Filter
        class String < ::CASA::Attribute::Strategy::Base

          def process payload

            if options.has_key? 'blacklist'
              process_blacklist payload
            else
              true
            end

          end

          private

          def process_blacklist payload

            attr = attribute_from payload

            accept = true
            @options['blacklist'].each do |match_string|
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