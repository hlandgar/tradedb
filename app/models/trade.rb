class Trade < ActiveRecord::Base

	
	belongs_to :user
	has_many :entries, dependent: :destroy, before_add: :set_nest

	accepts_nested_attributes_for :entries, allow_destroy: true
	validates_associated :entries


	before_save :set_position, :open_pl



	attr_accessor :spread

	default_scope -> { order('created_at DESC')}
	scope :open, -> { where( open: true ) }
	scope :closed, -> { where( open: false ) }

	attr_accessor :pass

	


	validates :user_id, presence: true, numericality: { only_integer: true }
	validates :comments, length: { maximum: 199 }
	validates :symbol, presence: true
	validates :prob1, presence: true, numericality: { greater_than: 0, less_than: 100 }
	validates :fill, presence: true, numericality: { greater_than: 0 }
	validates :stop, presence: true, numericality: { greater_than: 0 }
	validates :targ1, presence: true, numericality: { greater_than: 0 }
	validates :prob2, numericality: { greater_than_or_equal_to: 0, less_than: 100 }, allow_blank: true
	validates :targ2, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates :stop2, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates :sellpct, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

	def set_position	

		self.position = entries.map(&:quantity).sum	if entries.any?
		self.open = self.position != 0	
		return true
	end

	def self.get_market_condition
		["Vert Up", "Vert Down", "Balance", "Early", "Mature"]
	end

	def avg_price
		if self.position != 0
			self.entries.inject(0.0){ |prod, e| prod + (e.quantity * e.price) }  / self.position
		else
			self.entries.first.price
		end
		
	end

	def current_price
		if (quote = Security.quote(self.symbol)) != "no quote"
			if self.position > 0
				quote.bid_realtime
			elsif 	self.position < 0
					quote.ask_realtime
			else
				quote.last_trade_price_only
			end
		else
			"no quote"
		end
	end

	def open_pl
		try(security = find_sec(self.symbol))

		if open?
			return 0.0 if current_price.nil? or current_price == "no quote"
			self.pl = self.position * security.tickval.to_f * (current_price - avg_price) / security.tick_size.to_f
		else

			self.pl = security.tickval.to_f * 
				self.entries.inject(0.0){|sum, e| sum + (-e.quantity * e.price) } / security.tick_size.to_f				
		end
	end

	def closed?
		self.open == false
	end

	def open?
		self.open == true
	end

	def self.open_eq(user)
		user.trades.open.sum(:pl).to_f
	end

	def self.closed_eq(user)
		user.trades.closed.sum(:pl).to_f
	end
	
	
	
	private

	def l_or_s
		if self.open
			self.position > 0 ? 1.0 : -1.0
		else
			0.0
		end 		
	end

	def set_nest(entry)
		entry.trade ||= self
	end

	def all_secs
		(Quotebase.default_securities + User.find(self.user_id).securities).uniq(&:symbol)
	end

	def find_sec(symbol)
		all_secs.select {|i| i.symbol == symbol }.first
	end

end
