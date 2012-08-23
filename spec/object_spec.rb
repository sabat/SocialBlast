require 'spec_helper'

describe Object do
  it { should respond_to(:blank?) }
  it { should respond_to(:present?) }

  context "when object is nil" do
    subject { nil }
    it { should be_blank }
    it { should_not be_present }
  end

  context "when object is empty" do
    subject { '' }
    it { should be_blank }
    it { should_not be_present }
  end

  context "when object is not empty" do
    subject { 'foo' }
    it { should_not be_blank }
    it { should be_present }
  end

end
