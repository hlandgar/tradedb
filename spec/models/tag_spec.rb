require 'spec_helper'

describe Tag do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category, user: user) }
  before { @tag = category.tags.build(name: "Initiative trade at extreme", category: category) }

  subject { @tag }

  it { should respond_to(:name) }
  it { should respond_to(:category_id) }
  its(:category) { should eq category } 

  it { should be_valid }

  describe "with category_id is not present" do
  	before { @tag.category_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank name" do
  	before { @tag.name = " " }
  	it { should_not be_valid }
  end

  describe "with name that is too long" do
  	before { @tag.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "with name that is duplicate" do
  	before do
  		tag_with_same_name = @tag.dup
  		tag_with_same_name.name = @tag.name.upcase
  		tag_with_same_name.save
  	end
  	it { should_not be_valid }
  end

end
