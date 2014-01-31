require 'casa/attribute/strategy/squash/use_original'

module CASA
  module Attribute
    module Strategy
      module Squash
        class UseLatest < UseOriginal

          def process payload

            value = nil

            if payload.has_key?('journal')
              payload['journal'].reverse.each do |entry|
                if entry.has_key?(section) and entry[section].has_key?(name)
                  value = entry[section][name]
                  break
                end
              end
            end

            value ? value : super(payload)

          end

        end
      end
    end
  end
end