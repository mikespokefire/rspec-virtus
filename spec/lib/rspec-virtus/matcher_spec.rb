require 'spec_helper'
require 'virtus'

describe RSpec::Virtus::Matcher do
  let(:instance) { described_class.new(attribute_name) }
  let(:attribute_name) { :the_attribute }

  class DummyAttribute < Virtus::Attribute; end
  class DummyVirtus
    include Virtus.model

    attribute :the_attribute, String
    attribute :the_array_attribute, Array[String]
    attribute :custom_attribute, DummyAttribute
  end

  describe '#matches?' do
    subject { instance.matches?(actual) }
    let(:actual) { DummyVirtus }

    context 'successful match on attribute name' do
      it { is_expected.to eql(true) }
    end

    context 'successful match on attribute name and primitive type' do
      before { instance.of_type(String) }

      it { is_expected.to eql(true) }
    end

    context 'successful match on attribute name and attribute type' do
      before { instance.of_type(Axiom::Types::String) }

      it { is_expected.to eql(true) }
    end

    context 'successful match on attribute name and custom type' do
      let(:attribute_name) { :custom_attribute }
      before { instance.of_type(DummyAttribute) }

      it { is_expected.to eql(true) }
    end

    context 'successful match on attribute name, type and primitive member_type' do
      let(:attribute_name) { :the_array_attribute }

      before do
        instance.of_type(Array, member_type: String)
      end

      it { is_expected.to eql(true) }
    end

    context 'successful match on attribute name, type and attribute member_type' do
      let(:attribute_name) { :the_array_attribute }

      before do
        instance.of_type(Array, member_type: Axiom::Types::String)
      end

      it { is_expected.to eql(true) }
    end

    context 'unsuccessful match on attribute name' do
      let(:attribute_name) { :something_else }

      it { is_expected.to eql(false) }
    end

    context 'unsuccessful match on attribute name and type' do
      let(:attribute_name) { :something_else }

      before do
        instance.of_type(Integer)
      end

      it { is_expected.to eql(false) }
    end

    context 'unsuccessful match on attribute name, type and member_type' do
      let(:attribute_name) { :the_array_attribute }

      before do
        instance.of_type(Array, member_type: Integer)
      end

      it { is_expected.to eql(false) }
    end
  end

  describe '#of_type' do
    subject { instance.of_type(String) }

    it 'returns itsself so it can be chained' do
      expect(subject).to eql(instance)
    end

    context "singular values" do
      it 'adds an option to allow the type to be checked' do
        options_type = subject.instance_variable_get(:@options)[:type]
        expect(options_type).to eql(String)
      end
    end

    context "arrays of values" do
      subject { instance.of_type(Array, member_type: String) }

      it 'adds an option to allow the type to be checked' do
        options_type = subject.instance_variable_get(:@options)[:type]
        expect(options_type).to eql(Array)
      end

      it 'adds an option to allow the member_type to be checked' do
        member_options_type = subject.instance_variable_get(:@options)[:member_type]
        expect(member_options_type).to eql(String)
      end
    end
  end

  describe '#description' do
    subject { instance.description }

    it 'tells you which attribute we are testing' do
      expect(subject).to include(attribute_name.to_s)
    end
  end

  describe '#failure_message' do
    subject { instance.tap { |i| i.matches?(DummyVirtus) }.failure_message }

    context 'on absent attribute' do
      let(:attribute_name) { :something_else }

      it 'returns absence message' do
        message = 'expected :something_else to be defined in DummyVirtus'
        expect(subject).to eq message
      end
    end

    context 'on incorrect type' do
      before { instance.of_type(Integer) }

      describe 'attribute type' do
        context 'with primitive type' do
          it 'returns type primitive' do
            message = 'expected :the_attribute to be Integer, got String'
            expect(subject).to eq message
          end
        end

        context 'with attribute' do
          let(:attribute_name) { :custom_attribute }

          it 'returns type class' do
            message = 'expected :custom_attribute to be Integer, got DummyAttribute'
            expect(subject).to eq message
          end
        end
      end
    end

    context 'on incorrect member_type' do
      let(:attribute_name) { :the_array_attribute }

      before do
        instance.of_type(Array, member_type: Integer)
      end

      it 'returns wrong type message' do
        message = 'expected :the_array_attribute to be Array[Integer], got Array[String]'
        expect(subject).to eq message
      end
    end
  end
end
