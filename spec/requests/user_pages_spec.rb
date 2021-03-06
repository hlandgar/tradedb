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
	 	before do 
      sign_in user
      visit user_path(user) 
    end

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
				fill_in "Confirm Password",	with: "foobar"
        fill_in "Account size", with: "50000"
        fill_in "Kelly fraction", with: "3"
			end
	
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving user" do
				before { click_button submit }
			
				let(:user) { User.find_by(email: 'user@example.com')  }

				it { should have_link('Sign out') }
				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end
 	end



  describe "edit" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  	  sign_in user
  	  visit edit_user_path(user)
  	end

  	describe "page" do
  		it { should have_content("Update your profile") }
  		it { should have_title("Edit user") }
  		it { should have_link('change', href: 'http://gravatar.com/emails') }
  	end

  	describe "with valid information" do
  		let(:new_name) { "New Name" }
  		let(:new_email) { "new@example.com" }
  		before do
  		  fill_in "Name",		with: new_name
  		  fill_in "Email",		with: new_email
  		  fill_in "Password",	with: user.password
  		  fill_in "Confirm Password", with: user.password
        fill_in "Account size", with: "30000"
        fill_in "Kelly fraction", with: "4"
  		  click_button "Save changes"
  		end

  		it { should have_title(new_name) }
  		it { should have_selector('div.alert,alert-success') }
  		it { should have_link('Sign out', href: signout_path) }
  		specify { expect(user.reload.name).to eq new_name }
  		specify { expect(user.reload.email).to eq new_email }
  	end

  	describe "with invalid information" do
  		before { click_button "Save changes" }

  		it { should have_content('error') }
  	end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password, 
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end


  # describe "index" do

 	#   let(:user) { FactoryGirl.create(:user) }

	 #  before(:each) do
	 #    sign_in user
	 #    visit users_path
	 #  end

  # 	it { should have_title ('All users') }
  # 	it { should have_content ('user.name') }

  # 	describe "pagination" do

  # 		before(:all) { 30.times { FactoryGirl.create(:user) } }
  # 		after(:all) { User.delete_all }

  # 		it  { should have_selector('div.pagination') }

 	# 		it "should list each user" do
  # 			User.paginate(page: 1).each do |user|
  # 				expect(page).to have_selector('li', text: user.name)
  # 			end
  # 		end
  # 	end

  #   describe "delete links" do
      
  #     it { should_not have_link('delete') }

  #     describe "as an admin user" do
  #       let(:admin) { FactoryGirl.create(:admin) }
  #       before do
  #         sign_in admin
  #         visit users_path
  #       end

  #       it { should have_link('delete', href: user_path(User.first)) }
  #       it "should be able to delete another user" do
  #         expect do
  #           click_link('delete', match: :first)
  #         end.to change(User, :count).by(-1)
  #       end
  #       it { should_not have_link('delete', href: user_path(admin)) }
  #     end
  #   end
  # end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:t1) { FactoryGirl.create(:trade, user: user, desc: "long ES") }
    let!(:e1) { FactoryGirl.create(:entry, trade: t1) }
    let!(:t2) { FactoryGirl.create(:trade, user: user, desc: "long 6E") }
    let!(:e2) { FactoryGirl.create(:entry, trade: t2) }

    before do 
      sign_in user
      visit user_path(user) 
    end

    it { should have_content(user.name) }
    it { should have_title( user.name) }

    describe "trades" do
      it { should have_content(t1.desc) }
      it { should have_content(t2.desc) }
      it { should have_content(user.trades.count) }
    end
  end

  describe 'securities page' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:s1) { FactoryGirl.create(:security, user: user, symbol: "ES") }
    let!(:s2) { FactoryGirl.create(:security, user: user, symbol: "TF") }

    before do
      sign_in user
      visit user_securities_path(user)
    end

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe 'securities' do
      it { should have_content(s1.symbol) }
      it { should have_content(s2.symbol) }
      it { should have_content(user.securities.count) }
    end
    
  end
end

