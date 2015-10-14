require 'rails'

require "will_paginate_mongoid"
require "dynamic_form"
require "breadcrumbs"
require "paperclip"
require "ckeditor"

require "my_admin_mongoid/engine"
require "my_admin_mongoid/model"
require "my_admin_mongoid/string"
require "my_admin_mongoid/application"
require "my_admin_mongoid/locales"
require "my_admin_mongoid/to_xls"
require "my_admin_mongoid/breadcrumbs/my_admin"
require "my_admin_mongoid/ckeditor"

module MyAdmin
  
  def self.setup
    yield self
  end
  
  mattr_accessor :title
  @@title = "My Admin"
  
  mattr_accessor :url_prefix
  @@url_prefix = "admin"
  
end

require "my_admin_mongoid/paperclip"