module RSpec
  module Virtus
    class Matcher
      def initialize(attribute_name)
        @attribute_name = attribute_name
        @options = {}
      end

      def of_type(type)
        @options[:type] = type
        self
      end

      def matches?(subject)
        @subject = subject
        attribute_exists? && type_correct?
      end

      def failure_message
        "expected #{@attribute_name} to be defined"
      end

      def negative_failure_message
        "expected #{@attribute_name} not to be defined"
      end

      private

      def attribute
        @subject.attribute_set[@attribute_name]
      end

      def attribute_type
        attribute.options[:primitive]
      end

      def attribute_exists?
        attribute != nil
      end

      def type_correct?
        if @options[:type]
          attribute_type == @options[:type]
        else
          true
        end
      end
    end
  end
end
