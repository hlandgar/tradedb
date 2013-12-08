namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name: "Example User",
			email: "example@railstutorial.org",
			password: "foobar",
			password_confirmation: "foobar",
			account_size: 50000.00,
			kelly_fraction: 3,
			admin: true)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(name: name,
							email: email,
							password: password,
							password_confirmation: password,
							account_size: 50000.00,
							kelly_fraction: 3)
		end
		Quotebase.create!(symbol:"ES", yahoo_symbol:"ESZ13.CME")
	end
end