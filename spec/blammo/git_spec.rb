require 'spec_helper'

describe Blammo::Git do
  before do
    @git  = Git.init
    @log  = Git::Log.new(@git)

    stub(Git).open(anything) {@git}
    stub(Git::Log).new(anything, numeric) {@log}
  end

  describe ".commits" do
    before do
      stub(@log).between.with_any_args
      stub(Blammo::Git).each_commit(anything)

      @path = "foo/bar"
      Blammo::Git.commits(@path)
    end

    it "should open the repo at the given path" do
      Git.should have_received.open(@path)
    end

    it "should open the log" do
      Git::Log.should have_received.new(@git, 10)
    end

    it "should loop through each commit in the log" do
      Blammo::Git.should have_received.each_commit(@log)
    end

    it "should not scope the log" do
      @log.should_not have_received.between.with_any_args
    end

    context "with a SHA" do
      before do
        @sha = "abcd"
        Blammo::Git.commits(@path, @sha)
      end

      it "should scope the log" do
        @log.should have_received.between(@sha, "head")
      end
    end
  end

  describe ".each_commit" do
    before do
      @commit = Object.new
      stub(@log).each.yields(@commit)
    end

    it "should yield each commit in the log" do
      commits = []
      Blammo::Git.each_commit(@log) do |commit|
        commits << commit
      end
      commits.should include(@commit)
    end
  end
end
