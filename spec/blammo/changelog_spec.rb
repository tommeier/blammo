require 'spec_helper'

describe Blammo::Changelog do
  before(:all) do
    @releases_hash = [
      {"1.1" => [
        "commit one"
      ]},
      {"1.0" => [
        {"867b20e695e2b3770e150b0e844cdb6addd48ba4" => nil},
        {"3b183d9d1ec270fc63ef54695db1cd2df5d597cf" => "commit three"},
      ]}
    ]

    @releases = [
      Blammo::Release.new("1.1", [
        Blammo::Commit.new(nil, "commit one")
      ]),
      Blammo::Release.new("1.0", [
        Blammo::Commit.new("867b20e695e2b3770e150b0e844cdb6addd48ba4", nil),
        Blammo::Commit.new("3b183d9d1ec270fc63ef54695db1cd2df5d597cf", "commit three"),
      ])
    ]
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
