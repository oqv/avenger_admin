module MyAdmin
  
  module Generators

    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
  
      source_root File.expand_path('../templates', __FILE__)
  
      def generate_install
        
   		template "config/initializers/my_admin.rb", "config/initializers/my_admin.rb"

      end
  
    end
    
  end
  
end