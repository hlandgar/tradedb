class Quotebase < ActiveRecord::Base

	validates :symbol, presence: true, uniqueness: { case_sensitive: false }
	validates :yahoo_symbol, presence: true



	def self.quote(symbol, options= {} )
		@@q_table = {} if options[:reload]
		@@q_table ||= {}
		if @@q_table.empty?
			keys = Quotebase.all.map(&:symbol)

			query = Quotebase.all.map(&:yahoo_symbol)
			stocks = StockQuote::Stock.quote(query)

			@@q_table = Hash[keys.zip stocks]			
		end

		@@q_table[symbol]
		
	end

end
