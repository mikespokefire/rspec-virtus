require 'spec_helper'

describe RSpec::Virtus do
  let(:instance) { Class.new { include RSpec::Virtus }.new  }

  describe '#have_attribute' do
    subject { instance.have_attribute(:attribute_name) }

    it 'returns a new matcher instance' do
      expect(subject).to be_an_instance_of(RSpec::Virtus::Matcher)
    end
  end
end
