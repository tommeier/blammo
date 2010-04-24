require 'spec_helper'

describe Blammo::Git do
  describe ".commits" do
    before do
      @path = "foo/bar"
      @git  = Git.init
      @log  = Git::Log.new(@git)

      stub(Git).open(anything) {@git}
      stub(Git::Log).new(anything, numeric) {@log}
      stub(Blammo::Git).each_commit(anything)

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
  end

  describe ".each_commit" do
    before do
      @commit = Object.new
      @log = Object.new
      stub(@log).skip
      stub(@log).size {0}
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
