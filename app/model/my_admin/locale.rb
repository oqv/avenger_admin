class MyAdmin::Locale
	include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :acronym, 		:type => String
  
  def to_s
    self.name
  end
  
end
