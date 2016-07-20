class Project < ActiveRecord::Base
  has_many :ias, dependent: :destroy
  belongs_to :user
end
