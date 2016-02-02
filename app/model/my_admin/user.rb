# -*- coding: utf-8 -*-
require 'digest'

class MyAdmin::User #< MyAdmin::Model
  include Paperclip::Glue
  include Mongoid::Document
  include Mongoid::Timestamps
  include MyAdmin::Model

  field :first_name,                :type => String
  field :last_name,                 :type => String
  field :username,                  :type => String
  field :superuser,                 :type => Boolean

  field :email,                     :type => String
  field :active,                    :type => Boolean, :default => true

  field :salt,                      :type => String
  field :encrypted_password,        :type => String

  field :photo_file_name,           :type => String
  field :photo_content_type,        :type => String
  field :photo_file_size,           :type => Integer
  field :photo_updated_at,          :type => DateTime
  field :encrypted_recover,         :type => String


  has_attached_file :photo,
    :styles => { :my_admin => "200x200#", :mini => "27x27#" },
    :path => ":rails_root/public/uploads/:class/:id/:basename_:style.:extension",
    :url => "/uploads/:class/:id/:basename_:style.:extension",
    :default_url => ":class/missing_:style.png"
    #:path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    #:url => "/system/:attachment/:id/:style/:filename"


  before_save :encrypt_password, :if => :should_validate_password?

  has_many :user_groups, :dependent => :destroy, :class_name => "MyAdmin::UserGroup"
  has_and_belongs_to_many :groups, :class_name => "MyAdmin::Group"

  #has_many :groups, :through => :user_groups

  has_many :logs, :class_name => "MyAdmin::Log"

  attr_accessor :old_password, :password
  # attr_accessible :full_name, :first_name, :last_name, :username, :photo, :superuser, :email, :old_password, :password, :password_confirmation, :active, :group_ids

  validate :check_old_password, :if => :should_validate_old_password?
  validates_uniqueness_of :username
  validates_uniqueness_of :email
  validates_presence_of :first_name, :username, :email
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_format_of :email, :with => /@/
  validates :password, :presence	=> true, :confirmation => true, :length	=> { :within => 6..40 }, :if => :should_validate_password?
  validates_attachment_content_type :photo, :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true

  config_my_admin do |admin|
    admin.application = "authentication"
    admin.list_display = [:full_name, :username, :email, :superuser, :active]
    admin.filters = [:full_name, :username, :email]
    admin.export_display = [:full_name, :username, :email, :superuser_export, :active_export ]
    admin.fieldsets = [{:fields => [:username, :password, :password_confirmation]},
                       {:name => :personal_information,
                        :fields => [:first_name, :last_name, :email, :photo]},
                       {:name => :permissions,
                        :fields => [:superuser, :active]},
                       {:name => :groups,
                        :fields => [:groups]}]
    admin.fields = {:email => { :type => :email},
                    :password => {:type => :password},
                    :password_confirmation => {:type => :password}}
  end
  scope :my_admin_order_full_name, lambda { |params|
    { :order_by => "first_name #{params[:order]}, last_name #{params[:order]}" } if params[:order].present?
  }

  scope :my_admin_filter_full_name, lambda { |params|
    { :conditions => ["concat_ws(' ',first_name,last_name) like ?", "%#{params[:full_name]}%"] } if params[:full_name].present?
  }

  def permissions
    @permissions ||= MyAdmin::Permission.where(:group_ids.in => self.groups.map(&:id))
  end

  def superuser_export
    self.superuser ? "Sim" : "Não"
  end

  def active_export
    self.active ? "Sim" : "Não"
  end

  def full_name
    if(self.last_name.blank?)
      self.first_name
    else
      "#{self.first_name} #{self.last_name}"
    end
  end
  alias_method :to_s, :full_name

  def full_name=(value)
    if value.blank?
      self.first_name = self.last_name = nil
    else
      a = value.split
      self.first_name = a[0]
      self.last_name = a[1, a.count-1].join(' ')
    end
  end

  def self.recover(username, email)
    user = find_by_username(username)
    if(user && user.email == email)
      user.recover_password()
      user
    else
      nil
    end
  end

  def self.authenticate(username, submitted_password)
    user = where(username: username).first
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find(id) rescue nil
    (user && user.salt == cookie_salt) ? user : nil
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def should_validate_password?
    (not password.blank?) || new_record? || (not old_password.nil?)
  end

  def should_validate_old_password?
    not old_password.nil?
  end

  def is_active?
    self.active
  end

  def recover_password()
    self.update_attribute(:encrypted_recover, encrypt("#{self.encrypted_password}#{DateTime.now}"))
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def check_old_password
       errors.add(:old_password, I18n.t("mongoid.errors.messages.invalid")) unless has_password?(old_password)
    end

end
