class MyAdmin::Permission
  include Mongoid::Document
  include Mongoid::Timestamps

  field :model,       :type => String
  field :name,        :type => String
  field :application, :type => String

  has_many :group_permissions, :dependent => :destroy, :class_name => "MyAdmin::GroupPermission"
  has_and_belongs_to_many :groups, :class_name => "MyAdmin::Group"
  #has_many :groups, :through => :group_permissions

  validates_presence_of :model, :name, :application
  validates_uniqueness_of :name, :scope => [:model, :name, :application]

  def to_s
    application = MyAdmin::Application.find(self.application)
    title = application.title rescue I18n.t!("mongoid.applications.my_admin.#{self.application}")
    title + " > " + self.model.constantize.title + " - " + I18n.t("my_admin.permissions.#{self.name}")
  end

  scope :by_user, lambda { |user_id|
    { :joins => {:groups => [:users]}, :conditions => {"my_admin_users.id" => user_id} }
  }

end
