require 'spec_helper'

describe Category do
  let(:user) { FactoryGirl.create(:user) }
  before { @category = user.categories.build(name: "Setups", user: user)}

  subject { @category }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  its(:user) { should eq user } 

  it { should be_valid }

  describe "with user_id is not present" do
  	before { @category.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank name" do
  	before { @category.name = " " }
  	it { should_not be_valid }
  end

  describe "with name that is too long" do
  	before { @category.name = "a" * 31 }
  	it { should_not be_valid }
  end

  describe "with name that is duplicate" do
  	before do
  		category_with_same_name = @category.dup
  		category_with_same_name.name = @category.name.upcase
  		category_with_same_name.save
  	end
  	it { should_not be_valid }
  end
end
