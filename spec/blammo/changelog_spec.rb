require 'spec_helper'

CHANGELOG_PATH = __FILE__.to_fancypath.dir / "../fixtures/changelog.yml"

describe Blammo::Changelog do
  describe ".last_sha" do
    context "with no releases" do
      before do
        @changelog = Blammo::Changelog.new("foobar.yml")
      end

      it "should return nil" do
        @changelog.last_sha.should be_nil
      end
    end

    context "with a release" do
      before do
        @changelog = Blammo::Changelog.new(CHANGELOG_PATH)
      end

      it "should return the SHA of the last commit" do
        @changelog.last_sha.should == "867b20e695e2b3770e150b0e844cdb6addd48ba4"
      end
    end
  end
end
