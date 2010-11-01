require 'spec_helper'

describe Blammo::Release do
  before do
    @name    = "foo"
    @commits = []
    @release = Blammo::Release.new(@name, @commits)
  end

  describe "#initialize" do
    subject { @release }

    its(:name)    { should == @name }
    its(:commits) { should == @commits }
  end

  describe "#add_commit" do
    it "should add the given commit" do
      commit = Object.new
      @release.commits.should_not include(commit)
      @release.add_commit(commit)
      @release.commits.should include(commit)
    end
  end

  describe "#to_s" do
    subject { @release.to_s }
    it { should == @name }
  end

  describe "#to_yaml" do
    subject { @release.to_yaml }
    it { should == {@name => @commits}.to_yaml }
  end

  describe "#each_commit" do
    before do
      stub(@tagged_commit   = Object.new).tag { :foo }
      stub(@untagged_commit = Object.new).tag

      @commits = [@tagged_commit, @untagged_commit]
      @release = Blammo::Release.new("bar", @commits)
    end

    context "with a tag" do
      it "should yield each commit which has the given tag" do
        commits = []
        @release.each_commit(:foo) do |commit|
          commits << commit
        end
        commits.should == [@tagged_commit]
      end
    end

    context "without a tag" do
      it "should yield each commit" do
        commits = []
        @release.each_commit do |commit|
          commits << commit
        end
        commits.should == @commits
      end
    end
  end
end
