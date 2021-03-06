FactoryGirl.define do
	factory :user do
		sequence(:name)	{ |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password	"foobar"
		password_confirmation	"foobar"
		kelly_fraction 3
		account_size 50000.00

		factory :admin do
			admin true
		end
	end

	factory :trade do
		comments "a trade"
		user
		open true
		pl 0
		fill 1780.00
		stop 1775.00
		targ1 1790.00
		targ2 0.0
		prob1 0.50
		prob2 0.0
		desc "long ES"
		kelly 0.0
		position 1
		symbol "ES"
		stop2 0
		market_condition []

	end

	factory :security do
		symbol "ES"
		security_type "Future"
		description "Emini S&P"
		currency "USD"
		tick_size 0.25
		tickval 12.50
		sort_order 1
		default_spread 1
		decimal_places 2
		user
	end

	factory :category do
		name "Setups"
		user		
	end

	factory :tag do
		name "Initiative trade at extreme"
		category
	end

	factory :entry do
		trade
		quantity 1
		entrytime "#{Time.now}"
		price 1780.00
	end

	factory :quotebase do
		symbol "ES"
		yahoo_symbol "ESZ13.CME"
		default '1'
		security_type "Future"
		description "Emini S&P 500 Futures"
		tick_size 0.25
		tickval 12.50
		default_spread 1
		decimal_places 2
		sort_order 10
	end

	
end