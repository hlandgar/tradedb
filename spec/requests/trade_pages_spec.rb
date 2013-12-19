require 'spec_helper'

describe "TradePages" do
	include Capybara::DSL

	def check_form
	  page.should have_no_css('form .fields input[id$=name]')
	  click_link 'Add New Entry'
	  page.should have_css('form .fields input[id$=name]', :count => 1)
	  find('form .fields input[id$=name]').should be_visible
	  find('form .fields input[id$=_destroy]').value.should == 'false'

	  click_link 'Remove'
	  find('form .fields input[id$=_destroy]').value.should == '1'
	  find('form .fields input[id$=name]').should_not be_visible

	  click_link 'Add New Entry'
	  click_link 'Add New Entry'
	  fields = all('form .fields')
	  fields.select { |field| field.visible? }.count.should == 2
	  fields.reject { |field| field.visible? }.count.should == 1
  end

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before do 
		sign_in user
		FactoryGirl.create(:security, user: user)
		FactoryGirl.create(:quotebase)
		@conditions = Trade.get_market_condition
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
					select "ES", from: "trade[symbol]"
				  fill_in "trade[fill]", with: "1777"
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
	

		describe "editing a trade" do
			let(:trade) { FactoryGirl.create(:trade, user: user, symbol: "ES", pass: false)  }

			before do	
				FactoryGirl.create(:entry, trade: trade)
				visit user_path(user)
			
			end
				it { should have_link("ES")}

				describe "edit a trade" do
					before do
						click_link "ES"
						check_form
					end  



					it { should have_content("Edit Trade")}

					describe "with invalid information" do
						before do
							click_link "Add New Entry"
							
							click_button "Update"
						end
						it { should have_content('error') }
					end

					describe "with valid information" do
						before do
						  click_link "Add New Entry"
						  fill_in "Quantity", with: 3
						  fill_in "Price", with: 1750.00
						  click_button "Update"
						end
						it { should have_content("Trade Updated")}
					end
				end

		end
	end
end
