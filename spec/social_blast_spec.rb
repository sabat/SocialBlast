require 'spec_helper'
require 'social_blast'

describe SocialBlast do
  before { SocialBlast::Services.stub(:constants).and_return([:Twitter]) }
  subject { SocialBlast }
  after { SocialBlast.on = true }

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
    SocialBlast.stub(:threshold_reached?).and_return(false)
    expect(SocialBlast.can_post?).to be_false
  end

  it "says it can't post if posting threshold is reached" do
    SocialBlast.stub(:threshold_reached?).and_return(true)
    expect(SocialBlast.can_post?).to be_false
  end

  it "says it can post if on and below posting threshold" do
    SocialBlast.stub(:threshold_reached?).and_return(false)
    expect(SocialBlast.can_post?).to be_true
  end

  its(:services_available) { should include(:Twitter) }

  context "when initializing" do
    subject { SocialBlast.new('test msg') }

    it "fails to initialize without a message payload" do
      expect { SocialBlast.new('') }.to raise_error(ArgumentError)
      expect { SocialBlast.new(nil) }.to raise_error(ArgumentError)
    end
  end

  context "when initialized" do
    let(:mock_twitter) { mock SocialBlast::Services::Twitter }
    let(:prep_successful_blast) do
      mock_twitter.stub(:name).and_return(:Twitter)
      mock_twitter.stub(:deliver).and_return(true)
      SocialBlast.any_instance.stub(:have_service?).with(:Twitter).and_return(true)
      SocialBlast.any_instance.stub(:configured?).with(:Twitter).and_return(true)
      SocialBlast::Services::Twitter.stub(:new).with(blast.message).and_return(mock_twitter)
      blast.add_service(:Twitter)
    end

    subject(:blast) { SocialBlast.new('test msg') }
    before { mock_twitter }

    its(:message) { should_not be_empty }

    it "extends the ShmStore class"

    it "does not deliver the payload if the 'on' switch isn't set" do
      SocialBlast.on = false
      blast.deliver.should be_false
      blast.deliver.should_not be_nil
    end

    it "can be configured to deliver to a service it knows" do
      prep_successful_blast
      blast.add_service(:Twitter).should be_true
      blast.delivering_to.should include(:Twitter)
    end

    it "cannot be configured to deliver to an unconfigured service" do
      SocialBlast::Services::Twitter.should_receive(:configured?).and_return(false)
      blast.add_service(:Twitter).should be_false
    end

    it "cannot be configured to deliver to an unknown service" do
      blast.add_service(:Plurk).should be_false
    end

    it "delivers the payload to Twitter if configured" do
      prep_successful_blast
      blast.deliver.should be_true
    end

    it "delivers the payload to HootSuite if configured"
    it "delivers the payload to Facebook if configured"
    it "delivers the payload to Google+ if configured"
    it "delivers the payload to Wordpress if configured"
    it "delivers the payload to Tumblr if configured"
    it "delivers the payload to LinkedIn if configured"
  end

  context "when posting" do
    let(:mock_twitter) { mock SocialBlast::Services::Twitter }
    before { mock_twitter }
    subject(:blast) { SocialBlast.new('test msg') }

    let(:prep_successful_blast) do
      mock_twitter.stub(:name).and_return(:Twitter)
      mock_twitter.stub(:deliver).and_return(true)
      SocialBlast.any_instance.stub(:have_service?).with(:Twitter).and_return(true)
      SocialBlast.any_instance.stub(:configured?).with(:Twitter).and_return(true)
      SocialBlast::Services::Twitter.stub(:new).with(blast.message).and_return(mock_twitter)
      blast.post_count.reset
      blast.add_service(:Twitter)
    end

    it "can report its threshold" do
      SocialBlast.threshold.should be_a_kind_of(Fixnum)
    end

    it "can have its threshold set" do
      SocialBlast.threshold = 3
      SocialBlast.threshold.should eq(3)
    end

    it "keeps track of posts per hour" do
      prep_successful_blast
      blast.deliver
      SocialBlast.post_count.value.should eq(1)
      blast.deliver
      SocialBlast.post_count.value.should eq(2)
    end

    it "allows the posts-per-hour threshold to be set"
    it "can report if the post threshold has been reached"
    it "resets the post count after one hour"
    it "will not post if the threshold has been reached"
    it "uses Rails.cache if running under Rails"
      # this is for ALL global values including .on
    it "uses a class attr if not running under Rails"
  end

end

