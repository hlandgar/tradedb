class Entry < ActiveRecord::Base
	belongs_to :trade

	after_destroy :save_parent


	attr_accessor :category

	validates_presence_of :trade

	with_options if: :run_validation? do |check|
		check.validates :price, presence: true, numericality: { greater_than: 0 }
		check.validates :quantity, presence: true, numericality: { only_integer: true, other_than: 0 }
		check.validates :entrytime, presence: true
	end

private

	def run_validation?

	(self.trade.pass == false or self.trade.pass.nil?) ? true : false

	end

	def save_parent
		self.trade.save
	end
end
	









