require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Filter
        class List < ::CASA::Attribute::Strategy::Base

          def process payload
            if options.has_key? 'blacklist'
              process_blacklist payload
            else
              true
            end
          end

          private

          def to_regex string
            if string[0] == '/' and string[string.length-1] == '/'
              /#{string[1,string.length-2]}/
            else
              /^#{string}$/
            end
          end

          def attribute payload
            attributes = payload['attributes']
            if attributes.has_key?(section) and attributes[section].has_key?(name)
              attributes[section][name]
            else
              nil
            end
          end

          def process_blacklist payload

            attr = attribute payload

            accept = true
            @options['blacklist'].each do |regex_string|
              if attr.match(to_regex(regex_string))
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