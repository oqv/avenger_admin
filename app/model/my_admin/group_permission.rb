class MyAdmin::GroupPermission
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :permission
  belongs_to :group
  
end