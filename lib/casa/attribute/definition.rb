module CASA
  module Attribute
    class Definition

      @@attribute_uuids = {}
      @@attribute_sections = {}
      @@attribute_squash_operations = {}
      @@attribute_filter_operations = {}
      @@attribute_transform_operations = {}

      def self.uuid uuid = nil
        @@attribute_uuids[self.name] = uuid if uuid
        @@attribute_uuids[self.name]
      end

      def self.section section = nil
        @@attribute_sections[self.name] = section if section
        @@attribute_sections.has_key?(self.name) ? @@attribute_sections[self.name] : []
      end

      def self.operation operation_name, proc, block
        operations = self.class_variable_get("@@attribute_#{operation_name}_operations".to_sym)
        if proc
          operations[self.name] = proc
        elsif block
          operations[self.name] = block
        end
        operations[self.name]
      end

      # invoke within child class definition as either:
      #
      #   squash do |payload|
      #     routine
      #   end
      #
      #   squash Proc.new { |payload| routine }
      #
      def self.squash proc = nil, &block
        self.operation 'squash', proc, block
      end

      def self.filter proc = nil, &block
        self.operation 'filter', proc, block
      end

      def self.transform proc = nil, &block
        self.operation 'transform', proc, block
      end

      attr_reader :name
      attr_reader :options

      def initialize name, options = nil

        @name = name
        @options = options ? options : {}

        if @@attribute_squash_operations.include?(self.class.name) and @@attribute_squash_operations[self.class.name].is_a?(Class)
          @squash_strategy = @@attribute_squash_operations[self.class.name].new(self, @options.has_key?('squash') ? @options['squash'] : nil)
        end

        if @@attribute_filter_operations.include?(self.class.name) and @@attribute_filter_operations[self.class.name].is_a?(Class)
          @filter_strategy = @@attribute_filter_operations[self.class.name].new(self, @options.has_key?('filter') ? @options['filter'] : nil)
        end

        if @@attribute_transform_operations.include?(self.class.name) and @@attribute_transform_operations[self.class.name].is_a?(Class)
          @transform_strategy = @@attribute_transform_operations[self.class.name].new(self, @options.has_key?('transform') ? @options['transform'] : nil)
        end
        
      end

      def instance_run payload, strategy
        instance_exec payload, &strategy
      end

      def uuid
        self.class.uuid
      end

      def section
        self.class.section
      end

      def squash payload
        if defined? @squash_strategy
          @squash_strategy.process(payload)
        else
          instance_run payload.to_hash, @@attribute_squash_operations[self.class.name]
        end
      end

      def filter payload
        if defined? @filter_strategy
          @filter_strategy.process(payload)
        else
          instance_run payload.to_hash, @@attribute_filter_operations[self.class.name]
        end
      end

      def transform payload
        if defined? @transform_strategy
          @transform_strategy.process(payload)
        else
          instance_run payload.to_hash, @@attribute_transform_operations[self.class.name]
        end
      end

    end
  end
end