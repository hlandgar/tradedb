require 'spec_helper'

describe "TradePages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before	{ sign_in user }

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
		end

		describe "with valid information" do
			
			before do
			
			end
		end
	end

end
