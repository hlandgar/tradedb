class Trade < ActiveRecord::Base
	
	belongs_to :user
	has_many :entries, dependent: :destroy, before_add: :set_nest

	accepts_nested_attributes_for :entries

	before_save :set_position



	default_scope -> { order('created_at DESC')}

	attr_accessor :pass

	


	validates :user_id, presence: true, numericality: { only_integer: true }
	validates :comments, length: { maximum: 199 }
	validates :security_id, presence: true, numericality: { only_integer: true }
	validates :prob1, presence: true, numericality: { greater_than: 0, less_than: 100 }
	validates :fill, presence: true, numericality: { greater_than: 0 }
	validates :stop, presence: true, numericality: { greater_than: 0 }
	validates :targ1, presence: true, numericality: { greater_than: 0 }
	validates :prob2, numericality: { greater_than_or_equal_to: 0, less_than: 100 }, allow_blank: true
	validates :targ2, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates :stop2, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
	validates :sellpct, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

	def set_position		
		self.position = self.entries.sum(:quantity) if self.entries.count > 0	
		self.open = self.position != 0	
	end

	private

	def set_nest(entry)
		entry.trade ||= self
	end

end
