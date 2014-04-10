module CASA
  module Attribute
    module Strategy
      class Base

        attr_reader :definition
        attr_reader :uuid
        attr_reader :name
        attr_reader :section
        attr_reader :operation

        def initialize definition, operation

          @definition = definition
          @uuid = definition.uuid
          @name = definition.name
          @section = definition.section
          @operation = operation

        end

        def options
          definition.options.has_key?(operation) ? definition.options[operation] : {}
        end

        def match_string_to_regex string

          if string[0] == '/' and string[string.length-1] == '/'
            /#{string[1,string.length-2]}/
          else
            /^#{string}$/
          end

        end

        def attribute_in? payload

          attrs = payload['attributes']
          attrs.has_key?(section) and attrs[section].has_key?(name) and !attrs[section][name].nil?

        end

        def attribute_from payload

          attribute_in?(payload) ? payload['attributes'][section][name] : nil

        end

      end
    end
  end
end