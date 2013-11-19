class Security < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('sort_order') }
	validates :user_id, presence: true
	validates :symbol, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
	validates :description, length: { maximum: 30 }
	validates :tickval, presence: true, numericality: true
	validates :tick_size, presence: true, numericality: true
	validates :sort_order, presence: true, numericality: { integer: true, greater_than: 0 }
	validates :default_spread, presence: true, numericality: { integer: true,
																														greater_than: 0,
																														less_than: 11 }
	validates :decimal_places, presence: true, numericality: { integer: true,
																														 greater_than: 0,
																														 less_than: 8 }
end
