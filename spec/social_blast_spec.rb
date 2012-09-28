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
      SocialBlast::Services::TwitterService.stub(:configured?).and_return(true)
      SocialBlast::Services::TwitterService.stub(:new).with(blast.message).and_return(mock_twitter)
    end

    subject(:blast) { SocialBlast.new('test msg') }
    before { mock_twitter }

    it { should be_kind_of(ShmStore) }
    its(:message) { should_not be_empty }

    it "can auto-add all available services" do
      prep_successful_blast
      blast.all_services.delivering_to.should eq [:TwitterService]
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
      blast.add_service(:PlurkService).should be_false
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
      SocialBlast.reset_post_count
      blast.add_service(:TwitterService)
    end

    let!(:time_now) { Time.now }

    #

    it "can report its threshold" do
      SocialBlast.threshold.should be_a_kind_of(Fixnum)
    end

    it "can have its threshold set" do
      SocialBlast.threshold = 3
      SocialBlast.threshold.should eq(3)
    end

    it "keeps track of posts per hour" do
      prep_successful_blast
      expect { blast.deliver }.to change { SocialBlast.post_counter.value }.to(1)
      expect { blast.deliver }.to change { SocialBlast.post_counter.value }.to(2)
    end

    it "allows the posts-per-hour threshold to be set" do
      SocialBlast.threshold = 42
      expect(SocialBlast.threshold).to eq(42)
    end

    it "reports if the post threshold has been reached" do
      SocialBlast.post_counter.value = 246
      SocialBlast.threshold_reached?.should be_true
    end

    it "reports if the post threshold has not been reached" do
      SocialBlast.post_counter.value = 0
      SocialBlast.threshold_reached?.should be_false
    end

    it "resets the post count after one hour" do
      SocialBlast.post_counter.value = SocialBlast.threshold
      SocialBlast.post_counter.timestamp = (Time.now - (60*60*2))
      SocialBlast.post_counter.increment

      SocialBlast.post_counter.value.should eq(1)
    end

    it "will not post if the threshold has been reached" do
      prep_successful_blast
      SocialBlast.post_counter.value = SocialBlast.threshold + 1

      expect { blast.deliver }.to raise_error(PostThresholdException)
    end

    it "reports the timestamp of when the threshold will reset" do
      prep_successful_blast
      SocialBlast.post_counter.value = SocialBlast.threshold + 1

      expect(SocialBlast.when_can_post).to be_kind_of(String)
      expect(SocialBlast.when_can_post).to_not be_empty
    end

    it "reports the current time if we have not reached the posting threshold" do
      prep_successful_blast
      SocialBlast.post_counter.value = SocialBlast.threshold  - 1
      Time.stub(:now).and_return(time_now)
      expect(SocialBlast.when_can_post).to eq time_now.to_s
    end
  end

end

