class Project < ActiveRecord::Base
  has_many :ia_lists, dependent: :destroy
  belongs_to :user
  has_many :workflow_steps
end
