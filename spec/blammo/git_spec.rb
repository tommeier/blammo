require 'spec_helper'

describe Blammo::Git do
  before do
    @git = Git.init
    @log = Git::Log.new(@git)

    stub(Git).open(anything) {@git}
    stub(Git::Log).new(anything, numeric) {@log}
  end

  describe ".commits" do
    before do
      @path = "foo/bar"

      stub(@log).between.with_any_args

      Blammo::Git.each_commit(@path) do
      end
    end

    it "should open the repo at the given path" do
      Git.should have_received.open(@path)
    end

    it "should open the log" do
      Git::Log.should have_received.new(@git, 10)
    end

    it "should not scope the log" do
      @log.should_not have_received.between.with_any_args
    end

    context "with a SHA" do
      before do
        @since = "abcd"

        Blammo::Git.each_commit(@path, @since) do
        end
      end

      it "should scope the log" do
        @log.should have_received.between(@since, "head")
      end
    end

    context "with commits" do
      before do
        @commit = Object.new

        stub(@commit).sha {"foo"}
        stub(@commit).message {" bar "}

        stub(@log).each.yields(@commit)
      end

      it "should yield each commit" do
        Blammo::Git.each_commit(@log) do |sha, message|
          sha.should     == "foo"
          message.should == "bar"
        end
      end
    end
  end
end
