require 'spec_helper'

describe Counter do
  subject { Counter.new }

  it "can be initialized" do
    expect { Counter.new }.to_not raise_error
  end

  context "when initialized" do
    its(:value) { should be_zero }
    its(:timestamp) { should be_kind_of(DateTime) }
    it { should be_kind_of(ShmStore) }
  end
end

