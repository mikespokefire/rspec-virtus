# Rspec::Virtus [![Build Status](https://travis-ci.org/mikespokefire/rspec-virtus.png?branch=master)](https://travis-ci.org/mikespokefire/rspec-virtus)

Simple RSpec matchers for your Virtus objects

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-virtus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-virtus

## Usage

Here is a sample Virtus object

    class Post
      include Virtus
      attribute :title, String
      attribtue :body, String
      attribtue :comments, Array[String]
    end

And with `rspec-virtus` we can now make simple assertions about these models

    require 'spec_helper'

    describe Post
      describe 'attributes' do
        it "has an attribute" do
          expect(described_class).to have_attribute(:title)
        end

        it "has an attribute with a type check" do
          expect(described_class).to have_attribute(:body).of_type(String)
        end

        it "has an array attribute with a type check" do
          expect(described_class).to have_attribute(:comments).of_type(Array, member_type: String)
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
