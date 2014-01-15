module CASA
  module Attribute
    class LoaderError < RuntimeError

      attr_reader :class_name
      attr_accessor :require_path

      def initialize class_name, require_path
        @class_name = class_name
        @require_path = require_path
      end

    end
  end
end