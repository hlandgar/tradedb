require 'spec_helper'

describe "CategoryPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "category creation" do
  	before { visit new_user_category_path(user) }

  	describe "with invalid information" do
  		
  		it "should not create a category" do
  			expect { click_button "Save" }.not_to change(Category, :count)
  		end

  		describe "error messages" do
  			before { click_button "Save" }
  			it { should have_css("div.alert-error") }
  		end
  	end

  	describe "with valid information" do
  		
  		before { fill_in 'Name', with: "Setups" }

  		it "should create category" do
  			expect { click_button "Save" }.to change(Category, :count).by(1)
  		end			
  	end  	
  end






  
end
