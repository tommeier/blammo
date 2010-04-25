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
    context "with automatically generated commit" do
      @sha      = "3b183d9d1ec270fc63ef54695db1cd2df5d597cf"
      @releases = [
        {"20100424175354" => [
          {@sha => "Lorem ipsum."}
        ]}
      ]

      Blammo::CLI.find_last_sha(@releases).should == @sha
    end

    context "with user generated commit" do
      @releases = [
        {"20100424175354" => [
          "Lorem ipsum."
        ]}
      ]

      Blammo::CLI.find_last_sha(@releases).should == nil
    end
  end
end
