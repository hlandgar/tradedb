class Tag < ActiveRecord::Base
	belongs_to :category



	validates :name, presence: true, length: { maximum: 50},
	 uniqueness: { case_sensitive: false, scope: :category_id }

	validates :category_id, presence: true
end
