module CASA
  module Attribute
    module Strategy
      class Base

        attr_reader :definition
        attr_reader :uuid
        attr_reader :name
        attr_reader :section
        attr_reader :options

        def initialize definition, options = nil

          @definition = definition
          @uuid = definition.uuid
          @name = definition.name
          @section = definition.section
          @options = options ? options : {}

        end

        def match_string_to_regex string

          if string[0] == '/' and string[string.length-1] == '/'
            /#{string[1,string.length-2]}/
          else
            /^#{string}$/
          end

        end

        def attribute_from payload

          attributes = payload['attributes']

          if attributes.has_key?(section) and attributes[section].has_key?(name)
            attributes[section][name]
          else
            nil
          end

        end

      end
    end
  end
end