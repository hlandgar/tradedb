class Tag < ActiveRecord::Base
	belongs_to :category



	validates :name, presence: true, length: { maximum: 50}
			
	validates :category_id, presence: true
end
