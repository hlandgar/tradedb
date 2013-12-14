class Entry < ActiveRecord::Base
	belongs_to :trade

	


	

	validates_presence_of :trade
	validates :price, presence: true, numericality: { greater_than: 0 }, if: :run_validation
	validates :quantity, presence: true, numericality: { only_integer: true, other_than: 0 }, if: :run_validation
	validates :entrytime, presence: true, if: :run_validation


private

	def run_validation
		self.trade.pass == false
		
	end
end
	









