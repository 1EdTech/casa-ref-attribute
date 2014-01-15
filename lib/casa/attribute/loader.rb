require 'casa/attribute/loader_class_error'
require 'casa/attribute/loader_file_error'
require 'casa/attribute/loader_attribute_error'

module CASA
  module Attribute
    class Loader

      @@loaded = {}

      def self.loaded
        @@loaded
      end

      def self.load! attribute
        CASA::Attribute::Loader.new(attribute).load_instance!
      end

      def initialize attribute
        @attribute = attribute.merge({'loaded_file'=>false})
        check_required
        process_path
        process_options
      end

      def load_file!
        begin
          require @attribute['path']
          @attribute['loaded_file'] = true
        rescue LoadError
          raise LoaderFileError.new @attribute['class'], @attribute['path']
        end
      end

      def load_instance!
        return if @@loaded[@attribute['name']]
        load_file! unless @attribute['loaded_file']
        begin
          class_object = @attribute['class'].split('::').inject(Object){|o,c| o.const_get c}
          @@loaded[@attribute['name']] = class_object.new @attribute['name'], @attribute['options']
        rescue NameError => e
          raise LoaderClassError.new @attribute['class'], @attribute['path']
        end
      end

      private

      def check_required
        ['class','name'].each { |key| raise LoaderAttributeError unless @attribute.has_key? key }
      end

      def process_path
        unless @attribute.has_key? 'path'
          @attribute['path'] = @attribute['class'].gsub('::','/').downcase
        end
      end

      def process_options
        @attribute['options'] = {} unless @attribute.has_key? 'options'
      end

    end
  end
end
