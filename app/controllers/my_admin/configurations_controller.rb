class MyAdmin::ConfigurationsController < MyAdmin::MyAdminController
  
  before_filter :add_breadcrumbs
  
  def show
    @condigurations = MyAdmin::Configuration.all
  end
  
  def update
    
    MyAdmin::Configuration.find_by_key(params[:pk]).update_attribute(:value, params[:value])
    
    render :nothing => true
  end

  private
  
    def add_breadcrumbs
      breadcrumbs.add('my_admin_home', send("#{admin_prefix}_path"))
    end

end