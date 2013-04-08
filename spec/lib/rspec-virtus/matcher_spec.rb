require 'spec_helper'
require 'virtus'

describe RSpec::Virtus::Matcher do
  let(:instance) { described_class.new(attribute_name) }
  let(:attribute_name) { :the_attribute }
  let(:type) { String }

  class DummyVirtus
    include Virtus

    attribute :the_attribute, String
  end

  describe '#matches?' do
    subject { instance.matches?(actual) }
    let(:actual) { DummyVirtus }

    context 'successful match on attribute name' do
      it 'returns true' do
        expect(subject).to eql(true)
      end
    end

    context 'successful match on attribute name and type' do
      it 'returns true' do
        expect(subject).to eql(true)
      end
    end

    context 'unsuccessful match on attribute name' do
      let(:attribute_name) { :something_else }

      it 'returns false' do
        expect(subject).to eql(false)
      end
    end

    context 'unsuccessful match on attribute name and type' do
      let(:attribute_name) { :something_else }
      let(:type) { Integer }

      it 'returns false' do
        expect(subject).to eql(false)
      end
    end
  end

  describe '#of_type' do
    subject { instance.of_type(type) }

    it 'adds an option to allow the type to be checked' do
      options_type = subject.instance_variable_get(:@options)[:type]
      expect(options_type).to eql(type)
    end

    it 'returns itsself so it can be chained' do
      expect(subject).to eql(instance)
    end
  end

  describe '#failure_message' do
    subject { instance.negative_failure_message }

    it 'tells you which attribute failed' do
      expect(subject).to include(attribute_name.to_s)
    end
  end

  describe '#negative_failure_message' do
    subject { instance.negative_failure_message }

    it 'tells you which attribute failed' do
      expect(subject).to include(attribute_name.to_s)
    end
  end
end
