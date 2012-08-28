require 'spec_helper'

class ShmStoreDummyClass; end

describe ShmStoreDummyClass do
  let(:set_rails_env) do
    Kernel.stub(:const_defined?).with('Rails').and_return(true)
    Rails = double('Rails')
    Rails.stub(:cache).and_return(Rails)
  end

  let(:set_no_rails_env) { Kernel.stub(:const_defined?).with('Rails').and_return(false) }
  let(:dummy_class) { ShmStoreDummyClass.new }

  before do
    dummy_class
    dummy_class.extend SocialBlast::ShmStore
  end

  after { Object.send(:remove_const, 'Rails') if Object.const_defined?('Rails') }

  it "can detect if it's running in Rails" do
    Kernel.should_receive(:const_defined?).with('Rails').and_return(true)
    dummy_class.rails?.should be_true
  end

  it "can detect if it is not running Rails" do
    dummy_class.rails?.should be_false
  end

  context "set_val" do
    it "sets a value using the Rails cache under Rails" do
      set_rails_env
      Rails.should_receive(:write).with('foo', 99).and_return(99)
      dummy_class.set_val('foo', 99).should eq(99)
    end

    it "sets a value in an instance variable if not under Rails" do
      set_no_rails_env
      dummy_class.set_val('foo', 'bar')
      dummy_class.instance_variable_get(:'@foo').should eq('bar')
    end
  end

  context "get_val" do
    it "gets a value using the Rails cache under Rails" do
      set_rails_env
      Rails.should_receive(:fetch).with('foo').and_return(99)
      dummy_class.get_val('foo').should eq(99)
    end

    it "sets a value in an instance variable if not under Rails" do
      set_no_rails_env
      dummy_class.instance_variable_set(:'@foo', 'bar')
      dummy_class.get_val('foo').should eq('bar')
    end
  end

end

