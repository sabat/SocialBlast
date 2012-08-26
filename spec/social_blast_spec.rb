require 'spec_helper'
require 'social_blast'

describe SocialBlast do
  before { SocialBlast::Services.stub(:constants).and_return([:TwitterService]) }
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

  its(:services_available) { should include(:TwitterService) }

  context "when initializing" do
    subject { SocialBlast.new('test msg') }

    it "fails to initialize without a message payload" do
      expect { SocialBlast.new('') }.to raise_error(ArgumentError)
      expect { SocialBlast.new(nil) }.to raise_error(ArgumentError)
    end
  end

  context "when initialized" do
    let(:mock_twitter) { mock SocialBlast::Services::TwitterService }
    let(:prep_successful_blast) do
      mock_twitter.stub(:service_name).and_return(:TwitterService)
      mock_twitter.stub(:deliver).and_return(true)
      SocialBlast.any_instance.stub(:have_service?).with(:TwitterService).and_return(true)
      SocialBlast.any_instance.stub(:configured?).with(:TwitterService).and_return(true)
      SocialBlast::Services::TwitterService.stub(:new).with(blast.message).and_return(mock_twitter)
      blast.add_service(:TwitterService)
    end

    subject(:blast) { SocialBlast.new('test msg') }
    before { mock_twitter }

    its(:on?) { should be_true }
    its(:message) { should_not be_empty }

    it { should be_kind_of(ShmStore) }

    it "says it can't post if it is not on" do
      SocialBlast.on = false
      blast.stub(:threshold_reached?).and_return(false)
      expect(blast.can_post?).to be_false
    end

    it "says it can't post if posting threshold is reached" do
      blast.stub(:threshold_reached?).and_return(true)
      expect(blast.can_post?).to be_false
    end

    it "says it can post if on and below posting threshold" do
      blast.stub(:threshold_reached?).and_return(false)
      expect(blast.can_post?).to be_true
    end

    it "does not deliver the payload if the 'on' switch isn't set" do
      SocialBlast.on = false
      expect { blast.deliver }.to raise_error(PostingDisabledException)
    end

    it "can be configured to deliver to a service it knows" do
      prep_successful_blast
      blast.add_service(:TwitterService).should be_true
      blast.delivering_to.should include(:TwitterService)
    end

    it "cannot be configured to deliver to an unconfigured service" do
      SocialBlast::Services::TwitterService.should_receive(:configured?).and_return(false)
      blast.add_service(:TwitterService).should be_false
    end

    it "cannot be configured to deliver to an unknown service" do
      blast.add_service(:Plurk).should be_false
    end

    it "can be configured to remove a service from delivery" do
      prep_successful_blast

      blast.remove_service(:TwitterService).should be
      blast.delivering_to.should_not include(:TwitterService)
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
    let(:mock_twitter) { mock SocialBlast::Services::TwitterService }
    before { mock_twitter }
    subject(:blast) { SocialBlast.new('test msg') }

    let(:prep_successful_blast) do
      mock_twitter.stub(:service_name).and_return(:TwitterService)
      mock_twitter.stub(:deliver).and_return(true)
      SocialBlast.any_instance.stub(:have_service?).with(:TwitterService).and_return(true)
      SocialBlast.any_instance.stub(:configured?).with(:TwitterService).and_return(true)
      SocialBlast::Services::TwitterService.stub(:new).with(blast.message).and_return(mock_twitter)
      blast.post_count.reset
      blast.add_service(:TwitterService)
    end

    it "can report its threshold" do
      SocialBlast.threshold.should be_a_kind_of(Fixnum)
    end

    it "can have its threshold set at the class level" do
      SocialBlast.threshold = 3
      SocialBlast.threshold.should eq(3)
    end

    it "keeps track of posts per hour" do
      prep_successful_blast
      blast.deliver
      blast.post_count.value.should eq(1)
      blast.deliver
      blast.post_count.value.should eq(2)
    end

    it "allows the posts-per-hour threshold to be set" do
      blast.class.threshold = 42
      expect(blast.class.threshold).to eq(42)
    end

    it "reports if the post threshold has been reached" do
      blast.post_count.value = 246
      blast.threshold_reached?.should be_true
    end

    it "reports if the post threshold has not been reached" do
      blast.post_count.value = 0
      blast.threshold_reached?.should be_false
    end

    it "resets the post count after one hour" do
      blast.post_count.value = blast.threshold
      blast.post_count.timestamp = (Time.now - (60*60*2))
      blast.post_count.increment

      blast.post_count.value.should eq(0)
    end

    it "will not post if the threshold has been reached" do
      prep_successful_blast
      blast.post_count.value = blast.threshold + 1

      expect { blast.deliver }.to raise_error(PostThresholdException)
    end
  end

end

