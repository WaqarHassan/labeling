
class L1 < ActiveRecord::Base
  has_many :l2s, dependent: :destroy
  belongs_to :user
  belongs_to :work_flow
  has_many :workflow_live_steps, as: :object
  has_many :attribute_values, as: :object
  has_many :additional_info, as: :object
  has_many :timestamp_logs, -> { order 'actual_confirmation desc' }, through: :workflow_live_steps
  validates :name, uniqueness: true
  #validate :uniqueness_of_name
  #validates :name, uniqueness: {:message => "must be unique!" }

  def uniqueness_of_name
   existing_record = L1.find_by_name(name)
   unless existing_record.nil?
     errors.add(:name, "Record #{existing_record.id} already has the name #{name}")
   end
  end

  class << self

    def set_db_datetime_format(date_time)
    	date_time_split = date_time.split(' ')

    	date_value = date_time_split[0]
    	time_value = date_time_split[1]+' '+date_time_split[2]

    	date_value_split = date_value.split('/')
    	date_value_ordered = date_value_split[2]+'-'+date_value_split[0]+'-'+date_value_split[1]

    	datetime_ordered = date_value_ordered+' '+time_value
    	datetime_obj = datetime_ordered.to_datetime

    	datetime_formated = datetime_obj.strftime('%Y-%m-%d %H:%M')
    	return datetime_formated
    end

  end

end
