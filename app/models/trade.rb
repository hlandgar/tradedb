class Trade < ActiveRecord::Base
	
	belongs_to :user
	has_many :entries, dependent: :destroy

	accepts_nested_attributes_for :entries

	default_scope -> { order('created_at DESC')}

	


	validates :user_id, presence: true
	validates :comments, length: { maximum: 199 }
	validates :security_id, presence: true
	validates :prob1, presence: true
	validates :fill, presence: true, numericality: true
	validates :stop, presence: true
	validates :targ1, presence: true

end
