module CASA
  module Attribute
    class Definition

      @@attribute_uuids = {}

      def self.attribute_uuid uuid
        @@attribute_uuids[self.name.to_s] = uuid
      end

      def self.uuids
        @@attribute_uuids
      end

      def self.uuid
        @@attribute_uuids[self.name]
      end

    end
  end
end