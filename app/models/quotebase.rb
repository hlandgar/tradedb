class Quotebase < ActiveRecord::Base



	validates :symbol, presence: true, uniqueness: { case_sensitive: false }
	validates :yahoo_symbol, presence: true

	after_save  :reload_table

	cattr_accessor :q_table
	@@q_table = {}

	store_accessor :properties, :default, :security_type, :description, :currency, :tick_size, :tickval, :sort_order,
															:default_spread, :decimal_places

	

	validates_numericality_of :tick_size, :tickval, :default_spread, :decimal_places


	def self.quote(symbol, options= {} )
		:reload_table if options[:reload]

		@@q_table[symbol]
		
	end

	def self.default_securities
		quotes = Quotebase.where("properties-> 'default' = '1'" )
	end

	

	def reload_table
		@@q_table = {}

		if Quotebase.count > 0

			keys = Quotebase.all.map(&:symbol) 

			query = Quotebase.all.map(&:yahoo_symbol)

			
			stocks = StockQuote::Stock.quote(query) 


			@@q_table = Hash[keys.zip Array(stocks)]
		end


	end

	def default
		if %w{1 0}.include? super
			super == '1' ? true : false
		else
			super
		end
	end

end
