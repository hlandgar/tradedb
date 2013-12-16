require 'spec_helper'

describe Security do
  let(:user) { FactoryGirl.create(:user) }
  before { @security = user.securities.build(symbol: "ES", security_type: "Future", 
  												description: "Emini S&P",
  												currency: "USD",
  												tick_size: 0.25,
  												tickval: 12.50,
  												sort_order: 1,
  												default_spread: 1,
  												decimal_places: 2) }

  subject { @security }

  it { should respond_to(:symbol) }
  it { should respond_to(:user_id) }
  it { should respond_to(:security_type) }
  it { should respond_to(:description) }
  it { should respond_to(:currency) }
  it { should respond_to(:tickval) }
  it { should respond_to(:tick_size) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:default_spread) }
  it { should respond_to(:decimal_places) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @security.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank symbol" do
  	before { @security.symbol = " " }
  	it { should_not be_valid }
  end

  describe "with description that is too long" do
  	before { @security.description = "a" * 31 }
  	it { should_not be_valid }
  end

  describe "with tickval that is blank" do
  	before { @security.tickval = "" }
  	it { should_not be_valid }  	
  end

  describe "with tickval that is not numbers" do  	
  	before { @security.tickval = "aaaa"}
  	it { should_not be_valid }
  end

  describe "with tick_size that is blank" do
  	before { @security.tick_size = "" }
  	it { should_not be_valid }
  end

  describe "with tick_size that is not numbers" do
  	before { @security.tick_size = "aaa" }
  	it { should_not be_valid }
  end

  describe "with sort_order that is blank" do
  	before { @security.sort_order = "" }
  	it { should_not be_valid }
  end

  describe "with sort_order that is not an integer and greater than 0" do
  	before { @security.sort_order = -24 }
  	it { should_not be_valid }
  end

  describe 'with default_spread that is blank' do
  	before { @security.default_spread = "" }
  	it { should_not be_valid }
  end

  describe 'with default_spread that is not an integer greater that 0  and less than 11' do
  	before { @security.default_spread = 20 }
  	it { should_not be_valid }
  end

  describe 'with decimal_places that is blank' do
  	before { @security.decimal_places = "" }
  	it { should_not be_valid }
  end

  describe 'with decimal_places that is not an integer greater that 0  and less than 7' do
  	before { @security.decimal_places = 8.1 }
  	it { should_not be_valid }
  end
end
