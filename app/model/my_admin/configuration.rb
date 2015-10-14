class MyAdmin::Configuration
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key,              	:type => String
  field :name, 				:type => String
  field :field_type, 		:type => String
  field :hint, 				:type => String
  field :value, 			:type => String
  field :required, 			:type => Boolean
  
  validates_uniqueness_of :key
  
  def self.get_value(key)
    MyAdmin::Configuration.where(key: key).first.value rescue nil
  end
  
end