require 'spec_helper'

describe Entry do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:trade) { FactoryGirl.create(:trade, user: user) }

  before { @entry = trade.entries.build(quantity: 10, entrytime: "#{Time.now}", price: 1799.25) }

  subject { @entry }

  it { should respond_to(:quantity) }
  it { should respond_to(:entrytime) }
  it { should respond_to(:trade_id) }
  it { should respond_to(:price) }
  its(:trade) { should eq trade }

  it { should be_valid }

  describe 'when quantity is not present' do
  	before { @entry.quantity = nil }
  	it { should_not be_valid}
  end

  describe "when quantity is not a number" do
  	before { @entry.quantity = "a" * 4 }
  	it { should_not be_valid }
  end

  describe 'when quantity is not an integer' do
  	before { @entry.quantity = 23.5 }
  	it { should_not be_valid }
  end

  describe 'when trade_id is not present' do
  	before { @entry.trade_id = nil }
  	it { should_not be_valid }
  end

  describe 'when entrytime is not present' do
    before { @entry.entrytime = nil }
  	it { should_not be_valid }
  end

  describe 'when price is not present' do
    before { @entry.price = nil }
    it { should_not be_valid }
  end

  describe 'when price is not a positive number' do
    before { @entry.price = -50.25 }
    it { should_not be_valid }
  end

  describe 'with price is not a number' do
    before { @entry.price = "qqq" }
    it { should_not be_valid }
  end
end
