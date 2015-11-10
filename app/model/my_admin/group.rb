class MyAdmin::Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include MyAdmin::Model

  field :name,          :type => String
  field :description,   :type => String

  has_many :user_groups, :dependent => :destroy, :class_name => "MyAdmin::UserGroup"
  has_and_belongs_to_many :users, :class_name => "MyAdmin::User"
  #has_many :users, :through => :user_groups

  has_many :group_permissions, :dependent => :destroy, :class_name => "MyAdmin::GroupPermission"
  has_and_belongs_to_many :permissions, :class_name => "MyAdmin::Permission"
  #has_many :permissions, :through => :group_permissions

  validates_uniqueness_of :name
  validates_presence_of :name


  config_my_admin do |admin|
    admin.application = "authentication"
    admin.list_display = [:name, :description]
    admin.fieldsets = [{:fields => [:name, :description]},
                       {:name => :permissions,
                        :fields => [:permissions]}]
    admin.fields = {:description => {:type => :clear_text}}
  end

  def to_s
    self.name
  end

end
