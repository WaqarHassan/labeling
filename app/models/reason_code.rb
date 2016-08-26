class ReasonCode < ActiveRecord::Base
	belongs_to :work_flow
	has_many :additional_infos
end
