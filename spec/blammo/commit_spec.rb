require 'spec_helper'

describe Blammo::Commit do
  let(:sha)     { "foo" }
  let(:message) { "[ADDED] bar" }
  let(:commit)  { Blammo::Commit.new(sha, message) }

  subject { commit }

  describe "#initialize" do

    its(:sha)     { should == sha }
    its(:message) { should == "bar" }
    its(:tag)     { should == :added }
  end

  describe "#valid?" do
    subject { commit.valid? }

    context "with a message and tag" do
      it { should be_true }
    end

    context "without a message" do
      let(:message) { nil }
      it { should be_false }
    end

    context "without a tag" do
      let(:message) { "bar" }
      it { should be_false }
    end
  end

  describe "#to_s" do
    subject { commit.to_s }
    it { should == "bar" }
  end

  describe "#to_yaml" do
    context "with a SHA" do
      subject { commit.to_yaml }
      it { should == {sha => message}.to_yaml }
    end

    context "without a SHA" do
      subject { Blammo::Commit.new(nil, message).to_yaml }
      it { should == message.to_yaml }
    end
  end

  describe ".parse_tag" do
    context "with an 'ADDED' tag" do
      %w(added new).each do |tag|
        subject { Blammo::Commit.parse_tag(tag.to_s.upcase) }
        it { should == :added }
      end
    end

    context "with a 'CHANGED' tag" do
      %w(changed).each do |tag|
        subject { Blammo::Commit.parse_tag(tag.to_s.upcase) }
        it { should == :changed }
      end
    end

    context "with a 'FIXED' tag" do
      %w(fixed).each do |tag|
        subject { Blammo::Commit.parse_tag(tag.to_s.upcase) }
        it { should == :fixed }
      end
    end

    context "with an unknown tag" do
      subject { Blammo::Commit.parse_tag("FOO") }
      it { should be_nil }
    end
  end
end
