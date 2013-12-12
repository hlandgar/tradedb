class Trade < ActiveRecord::Base

	
	belongs_to :user
	has_many :entries, dependent: :destroy, before_add: :set_nest

	accepts_nested_attributes_for :entries

	before_save :set_position, :open_pl


	attr_accessor :spread

	default_scope -> { order('created_at DESC')}

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
	end

	def self.get_market_condition
		["Vert Up", "Vert Down", "Balance", "Early", "Mature"]
	end

	def avg_price

		self.entries.inject(0.0){ |prod, e| e.quantity * e.price }  / self.position
		
	end

	def current_price
		quote = Security.quote(self.symbol)
		self.position > 0 ? quote.bid_realtime : quote.ask_realtime
	end

	def open_pl
		try(security = find_sec(self.symbol))

		self.pl = self.position * security.tickval.to_f * (current_price - avg_price) / security.tick_size.to_f

	
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
