require 'spec_helper'

describe User do
  
  before { @user = User.new( name: "Example User", email: "user@example.com", password: "foobar",
  				password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:trades) }
  it { should respond_to(:securities) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

    describe "remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "when name not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when email is invalid" do
  	it "should be invalid" do
  		addresses = %w[ user@foo,com user_at_foo.org example.user@foo.
  						foo@bar_baz.com foo@bar+baz.com foo@bar..com ]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			expect(@user).not_to be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[ user@foo.COM A_US-ER@f.b.org frst.last@foo.jp a+b@baz.cn  ]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when email is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before do
  		@user = User.new(name: "Example User", email: "user@example.com", password: " ", 
  			password_confirmation: " ")
  	end
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "email address with mixed case" do
  	let(:mixed_case_email) { "FooBar@IbM.CoM" }
  	it "should be saved lowercase" do
  		@user.email = mixed_case_email
  		@user.save
  		expect(@user.reload.email).to eq mixed_case_email.downcase
  	end
  end

  describe "trade associations" do
    
    before { @user.save }
    let!(:older_trade ) { FactoryGirl.create( :trade, user: @user, created_at: 1.day.ago) }
    let!(:newer_trade) { FactoryGirl.create( :trade, user: @user, created_at: 1.hour.ago) }

    it "should have the right trades in the right order" do
      expect(@user.trades.to_a).to eq [newer_trade,older_trade]
    end

    it "should destroy associationed trades" do
      trades = @user.trades.to_a
      @user.destroy
      expect(trades).not_to be_empty
      trades.each do |trade|
        expect(Trade.where(id: trade.id)).to be_empty
      end
    end
  end

  describe "security associations" do
    before { @user.save }
    let!(:second_security) { FactoryGirl.create(:security, user: @user, sort_order: 2, symbol: "TF") }
    let!(:first_security) { FactoryGirl.create(:security, user: @user, sort_order: 1, symbol: "ES" ) }
    
    it "should have the right securities in the right order" do
      expect(@user.securities.to_a).to eq [first_security, second_security]
    end

    it "should destroy associated securites" do
      securities = @user.securities.to_a
      @user.destroy
      expect(securities).not_to be_empty
      securities.each do |security|
        expect(Security.where(id: security.id)).to be_empty
      end
    end
  end
end
