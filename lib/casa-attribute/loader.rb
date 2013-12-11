require 'casa-attribute/loader_class_error'
require 'casa-attribute/loader_file_error'

module CASA
  module Attribute
    class Loader

      @@loaded = {}

      def self.loaded
        @@loaded
      end

      def self.load! attribute

        return unless attribute.has_key? :class

        unless attribute.has_key? :path
          attribute[:path] = attribute[:class].gsub(/^CASA::Attribute::/, 'casa-attribute/').gsub('::','/').downcase
        end

        begin
          require attribute[:path]
          @@loaded[attribute[:name]] = attribute[:class].split('::').inject(Object) {|o,c| o.const_get c}
        rescue NameError
          raise LoaderClassError.new attribute[:class], attribute[:path]
        rescue LoadError
          raise LoaderFileError.new attribute[:class], attribute[:path]
        end

      end

    end
  end
end
