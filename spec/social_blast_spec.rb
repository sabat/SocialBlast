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

  it "says it can't post if it is not on" do
    SocialBlast.on = false
    SocialBlast.stub(:posting_threshold_reached?).and_return(false)
    expect(SocialBlast.can_post?).to be_false
  end

  it "says it can't post if posting threshold is reached" do
    SocialBlast.on = true
    SocialBlast.stub(:posting_threshold_reached?).and_return(true)
    expect(SocialBlast.can_post?).to be_false
  end

  it "says it can post if on and below posting threshold" do
    SocialBlast.on = true
    SocialBlast.stub(:posting_threshold_reached?).and_return(false)
    expect(SocialBlast.can_post?).to be_true
  end

  context "when initialized" do
    subject { SocialBlast.new('test msg') }

    it "takes a message payload"
    it "fails without a message payload"
    it "does not deliver the payload if the 'on' switch isn't set"
    it "delivers the payload to HootSuite if configured"
    it "delivers the payload to Twitter if configured"
    it "delivers the payload to Facebook if configured"
    it "delivers the payload to Google+ if configured"
  end

  context "when posting" do
    it "keeps track of posts per hour"
      # logic:
      # if counter var is nil, we are just starting,
      #    so reset
      # if countar var is NOT nil but the time now is
      #    > 1.hour from the saved timestamp, then reset
      # method: update!
      # method: post_threshold_reached?


    it "allows the posts-per-hour threshold to be set"
    it "can report if the post threshold has been reached"
    it "resets the post count after one hour"
    it "will not post if the threshold has been reached"
    it "uses Rails.cache if running under Rails"
    it "uses a class attr if not running under Rails"
  end

end

