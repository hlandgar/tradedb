require 'spec_helper'

describe Trade do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @trade = user.trades.build(comments: "first trade", open: true, pl:0, fill:1780, stop:1775,
            targ1:1790, prob1:0.50, desc: "long 1 ES", security_id: 1) }

  subject { @trade }

  it { should respond_to(:comments) }
  it { should respond_to(:user_id) }
  it { should respond_to(:open) }
  it { should respond_to(:user) }
  it { should respond_to(:pl) }
  it { should respond_to(:fill) }
  it { should respond_to(:stop) }
  it { should respond_to(:targ1) }
  it { should respond_to(:targ2) }
  it { should respond_to(:prob1) }
  it { should respond_to(:prob2) }
  it { should respond_to(:desc) }
  it { should respond_to(:kelly) }
  it { should respond_to(:open) }
  it { should respond_to(:position) }
  it { should respond_to(:security_id) }
  it { should respond_to(:stop2) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @trade.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when fill is not present" do
    before { @trade.fill = nil }
    it { should_not be_valid }
  end

  describe "when stop is not present" do
    before { @trade.stop = nil }
    it { should_not be_valid }
  end

  describe "when targ1 is not present" do
    before { @trade.targ1 = nil }
    it { should_not be_valid }
  end

  describe "when security_id is not present" do
    before { @trade.security_id = nil }
    it { should_not be_valid }
  end

  describe "when prob1 is not present" do
    before { @trade.prob1 = nil }
    it { should_not be_valid }
  end

  describe "with comments that are too long" do
    before { @trade.comments = "a" * 200 }
    it { should_not be_valid }
  end

  describe "When fill is not number" do
    before { @trade.fill = 'aaaa'}
    it { should_not be_valid }
  end
end 
