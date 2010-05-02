require 'spec_helper'

describe Blammo::Changelog do
  before(:all) do
    @releases_hash = [
      {"1.1" => [
        "[ADDED] commit one",
      ]},
      {"1.0" => [
        {"867b20e695e2b3770e150b0e844cdb6addd48ba4" => nil},
        {"3b183d9d1ec270fc63ef54695db1cd2df5d597cf" => "[FIXED] commit three"},
      ]}
    ]

    @releases = [
      Blammo::Release.new("1.1", [
        Blammo::Commit.new(nil, "[ADDED] commit one"),
      ]),
      Blammo::Release.new("1.0", [
        Blammo::Commit.new("867b20e695e2b3770e150b0e844cdb6addd48ba4", nil),
        Blammo::Commit.new("3b183d9d1ec270fc63ef54695db1cd2df5d597cf", "[FIXED] commit three"),
      ])
    ]

    @tagged_commits = [
      Blammo::Commit.new("867b20e695e2b3770e150b0e844cdb6addd48ba4", "[ADDED] Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
      Blammo::Commit.new("3b183d9d1ec270fc63ef54695db1cd2df5d597cf", "[CHANGED] Fusce accumsan laoreet semper."),
      Blammo::Commit.new("a7324e86b19ec68249ca0f9752a3277b0ad8c0c2", "[FIXED] Nunc ut magna eget libero porttitor mattis."),
    ]

    @non_tagged_commits = [
      Blammo::Commit.new("5fd6e8dea3d8c79700fccb324ba4a9b00918afa3", "Donec rhoncus lorem sed lorem vestibulum ultricies.")
    ]
  end

  describe "#initialize" do
    before do
      @path = "changelog.yml"

      stub(Blammo::Changelog).parse_releases {[]}
      stub(File).exists? {true}
      stub(YAML).load_file {[]}

      Blammo::Changelog.new(@path)
    end

    it "should load the given YAML file and parse it" do
      YAML.should have_received.load_file(@path)
      Blammo::Changelog.should have_received.parse_releases(anything)
    end

    context "with an invalid YAML file" do
      it "should warn the user" do
        pending
      end
    end
  end

  describe "#refresh" do
    before do
      @dir = "foo/bar"
      @last_sha = "867b20e695e2b3770e150b0e844cdb6addd48ba4"

      commits = @tagged_commits + @non_tagged_commits
      stub(Blammo::Changelog).last_sha {@last_sha}
      stub(Blammo::Git).commits {commits}

      @changelog = Blammo::Changelog.new("changelog.yml")

      @time_str = "20100501155804"
      @time     = Time.parse(@time_str)

      @release = Blammo::Release.new(@time_str)

      stub(Blammo::Release).new {@release}
      stub(@release).add_commit

      Timecop.freeze(@time) do
        @changelog.refresh(@dir)
      end
    end

    it "should load commits since the last SHA" do
      Blammo::Git.should have_received.commits(@dir, @last_sha)
    end

    it "should name the release with the current timestamp" do
      pending
    end

    it "should only add tagged commits to the latest release" do
      @tagged_commits.each do |commit|
        @release.should have_received.add_commit(commit)
      end

      @non_tagged_commits.each do |commit|
        @release.should_not have_received.add_commit(commit)
      end
    end
  end

  describe "#to_yaml" do
    before do
      stub(Blammo::Changelog).parse_releases {@releases}
      stub(@releases).to_yaml

      @changelog = Blammo::Changelog.new("changelog.yml")
      @changelog.to_yaml
    end

    it "should return the releases YAML" do
      @releases.should have_received.to_yaml({})
    end
  end

  describe ".last_sha" do
    context "with no releases" do
      it "should return nil" do
        Blammo::Changelog.last_sha([]).should be_nil
      end
    end

    context "with a release" do
      it "should return the SHA of the last commit" do
        Blammo::Changelog.last_sha(@releases).should == "867b20e695e2b3770e150b0e844cdb6addd48ba4"
      end
    end
  end

  describe ".parse_releases" do
    context "with no releases" do
      it "should return an empty array" do
        Blammo::Changelog.parse_releases([]).should be_empty
      end
    end

    context "with a release" do
      it "should should parse the releases hash" do
        pending
      end
    end
  end
end
