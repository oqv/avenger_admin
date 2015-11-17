module MyAdminLogHelper
  
  def create_log(user, application, mdl, item, action, before=nil, after=nil)
    MyAdmin::Log.create(:user => user, :object => item.id.to_s, :action => action, :application => application.key, :model => mdl.to_s, :before => before, after: after)
  end
  
end