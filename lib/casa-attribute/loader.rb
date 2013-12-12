require 'casa-attribute/loader_class_error'
require 'casa-attribute/loader_file_error'
require 'casa-attribute/loader_attribute_error'

module CASA
  module Attribute
    class Loader

      @@loaded = {}

      def self.loaded
        @@loaded
      end

      def self.load! attribute

        unless attribute.has_key?('name') and attribute.has_key?('name')
          raise LoaderAttributeError
        end

        unless attribute.has_key? 'path'
          attribute['path'] = attribute['class'].gsub(/^CASA::Attribute::/, 'casa-attribute/').gsub('::','/').downcase
        end

        unless attribute.has_key? 'options'
          attribute['options'] = {}
        end

        begin
          require attribute['path']
        rescue LoadError
          raise LoaderFileError.new attribute['class'], attribute['path']
        end

        begin
          class_object = attribute['class'].split('::').inject(Object){|o,c| o.const_get c}
          @@loaded[attribute['name']] = class_object.new attribute['name'], attribute['options']
        rescue NameError => e
          raise LoaderClassError.new attribute['class'], attribute['path']
        end

      end

    end
  end
end
