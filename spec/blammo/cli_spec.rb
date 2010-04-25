require 'spec_helper'

describe Blammo::CLI do
  describe "#generate" do
    it "should generate a changelog" do
      pending
    end
  end

  describe "#render" do
    it "should generate the changelog" do
      pending
    end
  end

  describe ".find_last_sha" do
    context "with no releases" do
      it "should return nil" do
        Blammo::CLI.find_last_sha([]).should be_nil
      end
    end

    context "with a release" do
      before do
        @sha      = "3b183d9d1ec270fc63ef54695db1cd2df5d597cf"
        @releases = [
          {"20100424175354" => [
            "foo bar",
            {@sha => "lorem ipsum"}
          ]}
        ]
      end

      it "should return the SHA of the last commit" do
        Blammo::CLI.find_last_sha(@releases).should == @sha
      end
    end
  end
end
