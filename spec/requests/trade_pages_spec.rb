require 'spec_helper'

describe "TradePages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before do 
		sign_in user
		FactoryGirl.create(:security, user: user)
	end

	describe "trade creation" do
		before { visit root_path }

		describe 'with invalid information' do
			
			it "should not create a trade" do
				expect { click_button "Post" }.not_to change(Trade, :count)
			end

			describe 'error messages' do
				before { click_button "Post" }
				it { should have_content("error") }
			end

			describe 'with invalid calc info' do
				before { click_button "Calculate"}
				it { should have_content("error") }				
			end
		end

		describe "with valid information" do
			describe "Calculate test" do
				before do
					select "ES", from: "Symbol"
				  fill_in "Fill", with: "1777"
				  fill_in "Stop", with: "1774"
				  fill_in "1st Target", with: "1789"
				  fill_in "trade[prob1]", with: "30"

				  click_button "Calculate"
				end

				it { should have_selector('td',"9.600%") }

				before do
				  fill_in "trade[targ2]", with: "1792"
				  fill_in "trade[prob2]", with: "15"
				  fill_in "trade[stop2]", with: ""

				  click_button "Calculate"
				end

				it { should have_selector('td', "1.100%") }

				before do 
					fill_in "trade[stop2]", with: "1785"
					click_button "Calculate"
				end

				it { should have_selector('td', "10.300%") }				
			end			
		end
	end
end
