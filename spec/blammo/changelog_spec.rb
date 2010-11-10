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
  end

  let(:changelog) { Blammo::Changelog.new("/tmp/changelog") }

  let(:name)    { "1.0.0" }
  let(:release) { Blammo::Release.new(name) }

  let(:sha)     { "foo" }
  let(:message) { "[ADDED] bar" }
  let(:commit)  { Blammo::Commit.new(sha, message) }

  subject { changelog }

  describe "#initialize" do
    before do
      @path = "/tmp/changelog.yml"

      stub(Blammo::Changelog).parse_releases { [] }
      stub(File).exists? { true }
      stub(YAML).load_file { [] }

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

  describe "#update" do
    let(:dir)   { "foo/bar" }
    let(:name)  { "1.0.0" }
    let(:since) { "867b20e695e2b3770e150b0e844cdb6addd48ba4" }

    before do
      release

      stub(Blammo::Changelog).last_sha { since }
      stub(Blammo::Release).new(name) { release }
      stub(release).update(dir, since)
      stub(changelog).add_release

      changelog.update(dir, name)
    end

    it { should have_received.add_release(release) }
  end

  describe "#add_release" do
    context "with a non-empty release" do
      before do
        stub(release).empty? { false }
        changelog.add_release(release)
      end

      its(:releases) { should include(release) }
    end

    context "with an empty release" do
      before do
        stub(release).empty? { true }
        changelog.add_release(release)
      end

      its(:releases) { should_not include(release) }
    end
  end

  describe "#to_yaml" do
    before do
      stub(Blammo::Changelog).parse_releases { @releases }
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
