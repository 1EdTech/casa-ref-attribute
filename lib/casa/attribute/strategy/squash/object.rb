require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Squash
        class Object < CASA::Attribute::Strategy::Base

          def process payload

            unless @options.has_key?('default')
              use_latest_from payload
            else
              case @options['default']
                when 'original'
                  use_original_from payload
                else
                  use_latest_from payload
              end
            end

          end

          def use_original_from payload

            if payload['original'].has_key?(section) and payload['original'][section].has_key?(name)
              payload['original'][section][name]
            else
              nil
            end

          end

          def use_latest_from payload

            value = nil

            if payload.has_key?('journal')
              payload['journal'].reverse.each do |entry|
                if entry.has_key?(section) and entry[section].has_key?(name)
                  value = entry[section][name]
                  break
                end
              end
            end

            value ? value : use_original_from(payload)

          end

        end
      end
    end
  end
end