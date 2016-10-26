
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

  # 
  # * *Description* :
  #   - validate :uniqueness_of_name
  #   - validates :name, uniqueness: {:message => "must be unique!" }
  def uniqueness_of_name
   existing_record = L1.find_by_name(name)
   unless existing_record.nil?
     errors.add(:name, "Record #{existing_record.id} already has the name #{name}")
   end
  end
  # 
  # * *Arguments* :
  #   - It accepts a collection of l2s Object ids
  # * *Description* :
  #   - It Gets a list of l2s Object ids and returns complete Objects
  #
  def get_searched_l2_objects(l2_list)
    L2.where(id: [l2_list], l1_id: self.id).order(:id)
  end
  
  def get_l2s_objects(include_canceled, include_completed)
    if include_canceled =='include_canceled' and include_completed == 'include_completed'
      return self.l2s.order(:id)
    elsif include_canceled =='include_canceled'
      return self.l2s.where(completed_actual: nil).order(:id)
    elsif include_completed == 'include_completed'
      return self.l2s.where.not(status: 'cancel').order(:id)         
    else 
      return self.l2s.where(completed_actual: nil).where.not(status: 'cancel').order(:id)
    end
  end
  # 
  # * *Arguments* :
  #   - It accepts a collection of Station Steps Object ids
  # * *Description* :
  #   - It Gets a list of Station Steps object ids and return Workflow Live Step objects
  #     for current l2s Object after quering from database
  #
  def get_workflow_live_steps(filter_stations)
    self.workflow_live_steps.where("station_step_id in (#{filter_stations})")
  end
  #
  # * *Description* :
  #   - It returns number of Languages of current Object
  #
  def get_num_lang
    num_lang_value = ''
    num_lang = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
    if num_lang.present?
      num_lang_value = num_lang.value
    end 
    return num_lang_value
  end
  #
  # * *Description* :
  #   - It returns Component type of current object
  #
  def get_comp_type
    comp_type_value = ''
    comp_type = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label like '%Comp Type%'").first
    if comp_type.present?
      comp_type_value = comp_type.value
    end 
    return comp_type_value
  end
  #
  # * *Description* :
  #   - It returns HORW value of current object
  #
  def get_horw
    horw_value = ''
    horw = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='Horw'").first
    if horw.present?
      horw_value = horw.value
    end 
    return horw_value
  end

  class << self
    #
    # * *Arguments* :
    #   - It accepts Datatime as parameter
    # * *Returns* :
    #   - It return database formated Datetime
    # * *Description* :
    #   - It change current datetime format to match database datetime format
    #
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
    #
    # * *Arguments* :
    #   - It accepts data as parameter
    # * *Returns* :
    #   - It return database formated Date
    # * *Description* :
    #   - It change the date format to match database date format
    #
    def set_db_date_format(date)

      date_value_split = date.split('/')
      date_value_ordered = date_value_split[2]+'-'+date_value_split[0]+'-'+date_value_split[1]

      date_obj = date_value_ordered.to_datetime

      date_formated = date_obj.strftime('%Y-%m-%d')
      return date_formated
    end

  end

end
