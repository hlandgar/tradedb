require 'spec_helper'

describe Quotebase do
  let(:user) { FactoryGirl.create(:user) }
  before { @quote = Quotebase.new(symbol: "ES", yahoo_symbol: "ESZ13.CME") }

  subject { @quote }

  it { should respond_to :symbol }
  it { should respond_to :yahoo_symbol }
  it { should respond_to :default }
  it { should respond_to :security_type }
  it { should respond_to :description }
  it { should respond_to :currency }
  it { should respond_to :tick_size }
  it { should respond_to :tickval }
  it { should respond_to :sort_order }
  it { should respond_to :default_spread }
  it { should respond_to :decimal_places }



  it { should be_valid }

  describe 'when symbol is blank' do
  	before { @quote.symbol = " " }
  	it { should_not be_valid }
  end

  describe 'when yahoo_symbol is blank' do
  	before { @quote.yahoo_symbol = " " }
  	it { should_not be_valid }
  end

  
end
