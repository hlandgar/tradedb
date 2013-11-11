require 'spec_helper'

describe "UserPages" do
 
 subject { page }

 describe "signup page" do
 	before { visit signup_path }

 	it { should have_selector('h1', text: 'Sign up') }
 	it { should have_title(full_title('Sign up')) }
 end

 describe "profile page" do
 	let(:user) { FactoryGirl.create(:user) }
 	before { visit user_path(user) }

 	it { should have_selector('h1', text: user.name) }
 	it { should have_title(user.name) }
 end

 describe "signup" do
 	
 	before { visit signup_path }

 	let(:submit) { "Create my Account" }

 	describe "with invalid information" do
 		it "should not create user" do
 			expect { click_button submit }.not_to change(User, :count)
 		end
 	end

 	describe "with valid information" do
 		before do
 			fill_in "Name",			with: "Example User"
 			fill_in "Email",		with: "user@example.com"
 			fill_in "Password",		with: "foobar"
 			fill_in "Confirmation",	with: "foobar"
 		end
 		
 		it "should create a user" do
 			expect { click_button submit }.to change(User, :count).by(1)
 		end

 		describe "after saving user" do
 			before do
 			  click_button submit
 			end
 			let(:user) { User.find_by(email: 'user@example.com')  }

 			it { should have_link('Sign out') }
 			it { should have_title(user.name) }
 			it { should have_selector('div.alert.alert-success', text: 'Welcome') }
 				
 			
 		end
 	end
 end
end
