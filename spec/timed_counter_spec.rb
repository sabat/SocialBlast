require 'spec_helper'

describe TimedCounter do
  it "can be initialized" do
    expect { TimedCounter.new }.to_not raise_error
  end

  context "when initialized" do
    subject(:counter) { TimedCounter.new }

    its(:value) { should be_zero }
    its(:timestamp) { should be_kind_of(Time) }

    it { should be_kind_of(ShmStore) }

    it "can have its interval set in minutes" do
      counter.interval = 90
      expect(counter.interval).to eq(90)
    end

    it "has a default interval of 60 minutes" do
      expect(counter.interval).to eq(60)
    end

    it "can have its value overridden" do
      counter.value = 42
      expect(counter.value).to eq(42)
    end

    it "can have its timestamp overridden" do
      test_time = Time.now - (60*120) # > 1.hour.ago
      counter.timestamp = test_time
      counter.timestamp.should eq(test_time)
    end

    it "can be incremented" do
      expect { counter.increment }.to change { counter.value }.by(1)
    end

    it "can be reset" do
      counter.increment
      expect { counter.reset }.to change { counter.value }.to(0)
    end

    its(:reset) { should eq(0) }

    it "resets itself after <interval> minutes" do
      counter.timestamp = Time.now - (60*120) # > 1.hour.ago
      counter.value = 51

      expect { counter.increment }.to change { counter.value }.to(1)
    end

    its(:to_s) { should eq('0') }
    its(:to_i) { should eq(0) }
  end
end

