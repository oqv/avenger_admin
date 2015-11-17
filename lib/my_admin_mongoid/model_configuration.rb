module MyAdmin
  class ModelConfiguration

    attr_accessor :collection, :member, :application, :list_display, :show_display, :export_display, :filters, :fieldsets, :fields, :permissions, :per_page, :audit

    def initialize(klass)
      begin
        @class = klass
        @collection = []
        @member = []
        @fields = {}
        @per_page = 10

        @application = "content"
        @permissions = [:list, :create, :update, :destroy, :export]

        @list_display = (klass.fields.map{ |key, obj| obj.name } - ['_id']) #, 'created_at', 'updated_at'])
        @fieldsets = [{:fields => (klass.fields.map{ |key, obj| obj.name } - ['_id']) }] # , 'created_at', 'updated_at']) }]
        @show_display = nil #(klass.columns.map{ |c| c.name } - ['id'])
        @export_display = nil #(klass.columns.map{ |c| c.name })
        @filters = nil
        @audit = false
      rescue
      end
    end

    def application_url
      #I18n.t!("my_admin.urls.applications."+@application) rescue @application
      @application
    end

    def url
      #I18n.t!("my_admin.urls.models.#{@class.model_tableize}") rescue @class.model_tableize
      @class.model_tableize
    end

    def url_single
      self.url.singularize
    end

    def can?(permission, user)
      (@permissions.member? permission.to_sym and (user.superuser or not user.permissions.to_a.find { |p| p.name == permission.to_s and p.model == @class.to_s and p.application == @application }.blank?))
    end

    def filters
      @filters || @list_display
    end

    def export_display
      @export_display || @show_display || @list_display
    end

  end
end
