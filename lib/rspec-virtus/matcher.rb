module RSpec
  module Virtus
    class Matcher
      MESSAGES = {
        undefined_attribute: 'expected :%{attribute} to be defined in %{subject}',
        incorrect_type: 'expected :%{attribute} to be %{expected}, got %{actual}'
      }.freeze

      attr_accessor :failure_message

      def initialize(attribute_name)
        @attribute_name = attribute_name
        @options = {}
      end

      def description
        "have #{@attribute_name} defined"
      end

      def of_type(type, options={})
        @options[:type] = type
        @options[:member_type] = options.delete(:member_type)
        self
      end

      def matches?(subject)
        @subject = subject

        failure = validate
        @failure_message = compose_message(failure) if failure

        failure.nil?
      end

      private

      def validate
        return [:undefined_attribute, {}] unless attribute_exists?
        return [:incorrect_type, expected_actual_types] unless type_correct?
      end

      def attribute
        @subject.attribute_set[@attribute_name]
      end

      def attribute_exists?
        !attribute.nil?
      end

      def type_correct?
        if @options[:member_type]
          type_match? && member_type_match?
        elsif @options[:type]
          type_match?
        else
          true
        end
      end

      def type_match?
        attribute_match?(attribute, @options[:type])
      end

      def member_type_match?
        attribute_match?(attribute.member_type, @options[:member_type])
      end

      def attribute_match?(actual, expected)
        [actual.class, actual.type, actual.primitive].include?(expected)
      end

      def compose_message(failure)
        key, params = failure
        MESSAGES[key] % { attribute: @attribute_name, subject: @subject }.merge(params)
      end

      def expected_actual_types
        {
          expected: pretty_type(@options[:type], @options[:member_type]),
          actual: pretty_type(
            pretty_attribute(attribute),
            @options[:member_type] && pretty_attribute(attribute.member_type)
          )
        }
      end

      def attribute_type
        attribute.primitive
      end

      def pretty_type(type, member_type = nil)
        return type.to_s unless member_type
        "#{type}[#{member_type}]"
      end

      def pretty_attribute(attribute)
        return attribute.class if attribute.primitive == BasicObject
        attribute.primitive
      end
    end
  end
end
