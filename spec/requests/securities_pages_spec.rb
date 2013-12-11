require 'spec_helper'

describe "SecuritiesPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before do
		FactoryGirl.create(:quotebase)
		sign_in user

	end

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

	describe 'Security edit' do
		let(:user) { FactoryGirl.create(:user) }
		let(:security) { FactoryGirl.create(:security, user: user) }

		before do
		  sign_in user
		  visit edit_user_security_path(user, security)
		end

		describe "page" do
			it { should have_content("Update your Security") }
			it { should have_title("Edit Security") }
		end

		describe 'with valid information' do			
			let(:new_symbol) { "new symbol" }
			let(:new_desc) { "new description" }
			before do
			  fill_in "Symbol",	with: new_symbol
			  fill_in "Description", with: new_desc
			  click_button "Save changes"
			end

			it { should have_selector('div.alert,alert-success') }
			specify { expect(security.reload.symbol).to eq new_symbol.upcase }
			specify { expect(security.reload.description).to eq new_desc }
		end

		describe 'when symbol is clicked on security#index' do

			before { visit user_securities_path(user) }
			

			it { should have_link'ES', href: edit_user_security_path(user,security) }

			describe 'should be able to click symbol and get edit page' do
				before { click_link 'ES' }
				it { should have_title("Edit Security") }
			end

			
			
				
			

		end

			
	
	end


end
