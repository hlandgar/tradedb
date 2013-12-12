class Quotebase < ActiveRecord::Base



	validates :symbol, presence: true, uniqueness: { case_sensitive: false }
	validates :yahoo_symbol, presence: true

	

	


	store_accessor :properties, :default, :security_type, :description, :currency, :tick_size, :tickval, :sort_order,
															:default_spread, :decimal_places



	validates_numericality_of :tick_size, :tickval, :default_spread, :decimal_places


	

	def self.default_securities
		Quotebase.where("properties-> 'default' = '1'" )
	end

	


	

	def default
		if %w{1 0}.include? super
			super == '1' ? true : false
		else
			super
		end
	end

end
