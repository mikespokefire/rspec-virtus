require "spec_helper"
require "virtus"

class DummyPost
  include Virtus.model

  attribute :title, String
  attribute :body, String
  attribute :comments, Array[String]
end

describe DummyPost do
  it { expect(described_class).to have_attribute(:title) }
  it { expect(described_class).to have_attribute(:body).of_type(String) }
  it { expect(described_class).to have_attribute(:body).of_type(Axiom::Types::String) }
  it { expect(described_class).to have_attribute(:comments).of_type(Array, member_type: String) }
end
