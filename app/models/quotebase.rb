class Quotebase < ActiveRecord::Base

	validates :symbol, presence: true, uniqueness: { case_sensitive: false }
	validates :yahoo_symbol, presence: true

	after_save :reload_table

	@@q_table = {}
	cattr_accessor :q_table


	def self.quote(symbol, options= {} )

		@@q_table = {} if options[:reload]
		@@q_table ||= {}
		if @@q_table.empty?
			:reload_table			
		end

		@@q_table[symbol] ||= "no quote"
		
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

end
