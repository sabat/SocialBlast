require 'spec_helper'
require 'social_blast'

describe SocialBlast do
  it "has a version number" do
    expect(SocialBlast.version).to_not be_empty
  end

  it "is on by default" do
    expect(SocialBlast.on?).to be_true
  end

  it "can be disabled" do
    SocialBlast.on = false
    expect(SocialBlast.on?).to be_false
  end

  context "when initialized" do
    subject { SocialBlast.new('test msg') }

    it "takes a message payload"
    it "fails without a message payload"
    it "does not deliver the payload if the 'on' switch isn't set"
    it "delivers the payload to Twitter if configured"
    it "delivers the payload to Facebook if configured"
    it "delivers the payload to Google+ if configured"
  end
end

