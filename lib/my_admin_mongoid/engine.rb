class Engine < Rails::Engine
  path =  File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  # paths.app << File.join(path, "app")
  config.assets.precompile += %w( ckeditor/* )
  config.assets.precompile += %w( my_admin/application.css my_admin/application_locked.css my_admin/application_off.css )
  config.assets.precompile += %w( my_admin/application.js my_admin/application_locked.js my_admin/application_off.js )
  config.assets.precompile += %w( my_admin_application.js my_admin_application_locked.js my_admin_application_off.js )
  config.assets.precompile += %w( my_admin/custom.js my_admin/custom.css )
  config.assets.precompile += %w( my_admin/favicon.ico )
  config.assets.precompile += %w( my_admin/apple-touch-icon-precomposed.png )
  config.assets.precompile += %w( my_admin/users/missing_mini.png )

  config.to_prepare do
    ActionView::Base.send :include, MyAdminHelper

    require "my_admin_mongoid/will_paginate/bootstrap_link_renderer"
  end

  config.after_initialize do
    Date::DATE_FORMATS[:default] = "%d/%m/%Y"
    Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"

    Mime::Type.register "application/vnd.ms-excel", :xls
  end

end
