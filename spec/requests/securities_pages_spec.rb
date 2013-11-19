require 'spec_helper'

describe "SecuritiesPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe 'security creation' do
		before { visit new_user_security_path(user) }

		describe 'with invalid information' do
			
			it "should not create a security" do
				expect { click_button "Save" }.not_to change(Security, :count)
			end

			describe "error messages" do
				before { click_button "Save" }
				it { should have_content('error') }
			end
		end


		describe "with valid information" do
			
			before do
			  fill_in 'Symbol', with: "ES"
			  fill_in 'Type of Security', with: "Future"
			  fill_in 'Description', with: "E-Mini S&P"
			  fill_in 'Base Currency', with: "USD"
			  fill_in 'Minimum Tick Size', with: ".25"
			  fill_in "Value of each Tick", with: "12.5"
			  fill_in "Place in symbol dropdown list", with: "10"
			  fill_in "Default bid/ask spread", with: "1"
			  fill_in "Decimal Places in quote", with: "2"			  
			end

			it "should create a security" do
				expect { click_button "Save" }.to change(Security, :count).by(1)
			end
		end
	end
end
