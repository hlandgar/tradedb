class Category < ActiveRecord::Base
	belongs_to :user
	has_many :tags, dependent: :destroy
	validates :name, presence: true, length: { maximum: 30 }, uniqueness: { case_sensitive: false, scope: :user_id }
	validates :user_id, presence: true

	DEFAULTS = %w{ Setups Exits }
end
