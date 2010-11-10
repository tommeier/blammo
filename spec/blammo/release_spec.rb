require 'spec_helper'

describe Blammo::Release do
  let(:name)    { "1.0.0" }
  let(:release) { Blammo::Release.new(name) }

  let(:sha)     { "foo" }
  let(:message) { "[ADDED] bar" }
  let(:commit)  { Blammo::Commit.new(sha, message) }

  subject { release }

  describe "#initialize" do
    context "with a name" do
      its(:name) { should == name }
    end

    context "without a name" do
      let(:name)     { nil }
      let(:time_str) { "20100501155804" }
      let(:time)     { Time.parse(time_str) }

      subject do
        result = nil
        Timecop.freeze(time) do
          result = Blammo::Release.new
        end
        result
      end

      its(:name) { should == time_str }
    end
  end

  describe "#update" do
    let(:dir)     { "foo/bar" }
    let(:since)   { "867b20e695e2b3770e150b0e844cdb6addd48ba4" }
    let(:sha)     { "3b183d9d1ec270fc63ef54695db1cd2df5d597cf" }

    before do
      commit

      stub(Blammo::Git).each_commit.yields(sha, message)
      stub(Blammo::Commit).new(sha, message) { commit }
      stub(release).add_commit

      release.update(dir, since)
    end

    it { should have_received.add_commit(commit) }
  end

  describe "#add_commit" do
    context "with a valid commit" do
      before do
        stub(commit).valid? { true }
        release.add_commit(commit)
      end

      its(:commits) { should include(commit) }
    end

    context "without a valid commit" do
      before do
        stub(commit).valid? { false }
        release.add_commit(commit)
      end

      its(:commits) { should_not include(commit) }
    end
  end

  describe "#to_s" do
    subject { release.to_s }
    it { should == release.name }
  end

  describe "#to_yaml" do
    subject { release.to_yaml }
    it { should == {release.name => release.commits}.to_yaml }
  end

  describe "#each_commit" do
    let(:added_commit)   { Blammo::Commit.new(sha, "[ADDED] foo") }
    let(:changed_commit) { Blammo::Commit.new(sha, "[CHANGED] bar") }
    let(:commits)        { [added_commit, changed_commit] }
    let(:release)        { Blammo::Release.new(name, commits) }

    context "with a tag" do
      it "should yield each commit which has the given tag" do
        yielded_commits = []
        release.each_commit(:added) do |commit|
          yielded_commits << commit
        end
        yielded_commits.should == [added_commit]
      end
    end

    context "without a tag" do
      it "should yield each commit" do
        yielded_commits = []
        release.each_commit do |commit|
          yielded_commits << commit
        end
        yielded_commits.should == commits
      end
    end
  end
end
