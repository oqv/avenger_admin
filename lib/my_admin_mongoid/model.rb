require "my_admin_mongoid/model_configuration"

module MyAdmin
  module Model
    attr_accessor :my_admin_user

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # scope :my_admin_order, ->(params) {
      #   order_by("#{params[:order_by]} #{params[:order]}") if params[:order_by].present? and params[:order].present?
      # }

      def my_admin_order(params)
        if params[:order_by].present? and params[:order].present?
          order_by("#{params[:order_by]} #{params[:order]}")
        else
          scoped()
        end
      end

      def my_admin_filter(model, field, params)
        if params[field].present? and !params[field].blank?
          where(field => /#{params[field]}/i )
        else
          scoped()
        end
      end

      def my_admin_filter_type_belongs_to(model, field, params)
        if params["#{field.to_s.singularize}_id"].present? and not params["#{field.to_s.singularize}_id"].blank?
          where("#{field.to_s.singularize}_id" => params["#{field.to_s.singularize}_id"])
        else
          scoped()
        end
      end

      def my_admin_filter_type_boolean(model, field, params)
        if params[field].present? and !params[field].blank?
          where("#{field}" => (params[field] == "true"))
        else
          scoped()
        end
      end

      def my_admin_filter_type_date(model, field, params)
        if params[field].present? and !params[field].blank?
          where("#{field} = #{(params[field].to_date rescue nil)}")
        else
          scoped()
        end
      end

      def config_my_admin
        yield @configuration ||= MyAdmin::ModelConfiguration.new(self)
      end
      
      def my_admin
        @configuration ||= MyAdmin::ModelConfiguration.new(self)
      end
      
      def title_plural
        begin
          I18n.t!("mongoid.models.plural.#{i18n}")
        rescue
          I18n.t!("mongoid.models.#{i18n_plural}") rescue model_titleize.pluralize
        end
      end
      
      def title
        I18n.t!("mongoid.models.#{i18n}") rescue model_titleize
      end
      
      def tableize
        name.tableize.gsub(%r{/}, '_')
      end
      
      def titleize
        name.titleize.gsub(%r{/}, ' ')
      end
      
      def underscore
        name.underscore.gsub(%r{/}, '_')
      end
      
      def i18n
        name.underscore.gsub(%r{/}, '.')
      end
      
      def i18n_plural
        name.underscore.pluralize.gsub(%r{/}, '.')
      end
      
      def model_tableize
        name.tableize.split('/').last
      end
      
      def model_titleize
        name.titleize.split('/').last
      end
      
      def model_underscore
        name.underscore.split('/').last
      end

    end

  end
end

# module MyAdmin
#   class Model

#     attr_accessor :my_admin_user

#     # scope :my_admin_order, lambda { |params|
#     #   { :order => "#{params[:order_by]} #{params[:order]}" } if params[:order_by].present? and params[:order].present?
#     # }
    
#     # scope :my_admin_filter, lambda { |model, field, params|
#     #   { :conditions => ["#{model.table_name}.#{field} like ?", "%#{params[field]}%"] } if params[field].present? and !params[field].blank?
#     # }
    
#     # scope :my_admin_filter_type_belongs_to, lambda { |model, field, params| 
#     #   { :conditions => {"#{model.table_name}.#{field.to_s.singularize}_id" => params["#{field.to_s.singularize}_id"].to_i} } if params["#{field.to_s.singularize}_id"].present? and params["#{field.to_s.singularize}_id"].to_i > 0
#     # }
    
#     # scope :my_admin_filter_type_boolean, lambda { |model, field, params| 
#     #   { :conditions => {"#{model.table_name}.#{field}" => params[field] == "true"} } if params[field].present? and !params[field].blank?
#     # }
    
#     # scope :my_admin_filter_type_date, lambda { |model, field, params| 
#     #   { :conditions => ["#{model.table_name}.#{field} = :date", {:date => (params[field].to_date rescue nil)} ] } if params[field].present? and !params[field].blank?
#     # }

#     def self.included(base)
#       base.extend(ClassMethods)
#     end

#     module ClassMethods
#       def my_admin_order(params)
#         if params[:order_by].present? and params[:order].present?
#           scoped(:order => "#{params[:order_by]} #{params[:order]}")
#         else
#           scoped()
#         end
#       end

#       def self.my_admin_filter(model, field, params)
#         if params[field].present? and !params[field].blank?
#           scoped(:conditions => ["#{model.table_name}.#{field} like ?", "%#{params[field]}%"])
#         else
#           scoped()
#         end
#       end

#       def self.my_admin_filter_type_belongs_to(model, field, params)
#         if params["#{field.to_s.singularize}_id"].present? and params["#{field.to_s.singularize}_id"].to_i > 0
#           scoped(:conditions => {"#{model.table_name}.#{field.to_s.singularize}_id" => params["#{field.to_s.singularize}_id"].to_i})
#         else
#           scoped()
#         end
#       end

#       def self.my_admin_filter_type_boolean(model, field, params)
#         if params[field].present? and !params[field].blank?
#           scoped(:conditions => {"#{model.table_name}.#{field}" => params[field] == "true"})
#         else
#           scoped()
#         end
#       end

#       def self.my_admin_filter_type_date(model, field, params)
#         if params[field].present? and !params[field].blank?
#           scoped(:conditions => ["#{model.table_name}.#{field} = :date", {:date => (params[field].to_date rescue nil)} ])
#         else
#           scoped()
#         end
#       end
#     end
    
#     def self.config_my_admin
#       yield @configuration ||= MyAdmin::ModelConfiguration.new(self)
#     end
    
#     def self.my_admin
#       @configuration ||= MyAdmin::ModelConfiguration.new(self)
#     end
    
#     def self.title_plural
#       begin
#         I18n.t!("mongoid.models.plural.#{i18n}")
#       rescue
#         I18n.t!("mongoid.models.#{i18n_plural}") rescue model_titleize.pluralize
#       end
#     end
    
#     def self.title
#       I18n.t!("mongoid.models.#{i18n}") rescue model_titleize
#     end
    
#     def self.tableize
#       name.tableize.gsub(%r{/}, '_')
#     end
    
#     def self.titleize
#       name.titleize.gsub(%r{/}, ' ')
#     end
    
#     def self.underscore
#       name.underscore.gsub(%r{/}, '_')
#     end
    
#     def self.i18n
#       name.underscore.gsub(%r{/}, '.')
#     end
    
#     def self.i18n_plural
#       name.underscore.pluralize.gsub(%r{/}, '.')
#     end
    
#     def self.model_tableize
#       name.tableize.split('/').last
#     end
    
#     def self.model_titleize
#       name.titleize.split('/').last
#     end
    
#     def self.model_underscore
#       name.underscore.split('/').last
#     end
    
#   end
# end