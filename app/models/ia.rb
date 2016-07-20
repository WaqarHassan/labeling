class Ia < ActiveRecord::Base
	belongs_to :project
	has_many :ecrs, dependent: :destroy
end
