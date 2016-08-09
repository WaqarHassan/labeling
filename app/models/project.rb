class Project < ActiveRecord::Base
  has_many :l2s, dependent: :destroy
  belongs_to :user
  belongs_to :work_flow
  has_many :workflow_steps

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
