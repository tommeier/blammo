require 'spec_helper'

describe Blammo::Changelog do
  before(:all) do
    @releases_hash = [
      {"1.1" => [
        "commit one",
      ]},
      {"1.0" => [
        {"867b20e695e2b3770e150b0e844cdb6addd48ba4" => nil},
        {"3b183d9d1ec270fc63ef54695db1cd2df5d597cf" => "commit three"},
      ]}
    ]

    @releases = [
      Blammo::Release.new("1.1", [
        Blammo::Commit.new(nil, "commit one"),
      ]),
      Blammo::Release.new("1.0", [
        Blammo::Commit.new("867b20e695e2b3770e150b0e844cdb6addd48ba4", nil),
        Blammo::Commit.new("3b183d9d1ec270fc63ef54695db1cd2df5d597cf", "commit three"),
      ])
    ]

    @commits = [
      Blammo::Commit.new("867b20e695e2b3770e150b0e844cdb6addd48ba4", "[ADDED] Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
      Blammo::Commit.new("3b183d9d1ec270fc63ef54695db1cd2df5d597cf", "[CHANGED] Fusce accumsan laoreet semper."),
      Blammo::Commit.new("a7324e86b19ec68249ca0f9752a3277b0ad8c0c2", "[FIXED] Nunc ut magna eget libero porttitor mattis."),
    ]
  end

  describe "#initialize" do
    it "should load the given YAML file and parse it" do
      pending
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

      stub(Blammo::Git).commits(@dir, anything) {@commits}
      stub(Blammo::Changelog).parse_releases {[]}

      @changelog = Blammo::Changelog.new("changelog.yml")

      @time_str = "20100501155804"
      @time     = Time.parse(@time_str)

      Timecop.freeze(@time) do
        @changelog.refresh(@dir)
      end
    end

    it "should only add prefixed commits to the latest release" do
      @changelog.releases.should == [
        Blammo::Release.new(@time_str, @commits)
      ]
    end
  end

  describe "#to_yaml" do
    it "should return the releases YAML" do
      pending
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
        Blammo::Changelog.parse_releases(@releases_hash).should == @releases
      end
    end
  end
end
