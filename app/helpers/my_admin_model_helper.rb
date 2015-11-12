module MyAdminModelHelper

  def collection_model_link(application, model, action, options={})
    send("#{action}_#{admin_prefix}_#{application.url}_#{model.my_admin.url}_path", options )
  end

  def member_model_link(application, model, action, options={})
    send("#{action}_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", options )
  end

  def model_link(application, model, options={})
    send("#{admin_prefix}_#{application.url}_#{model.my_admin.url}_path", options)
  end

  def new_model_link(application, model, options={})
    send("new_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", options )
  end

  def edit_model_link(application, model, item)
    send("edit_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", item)
  end

  def show_model_link(application, model, item)
    send("#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", item)
  end

  def destroy_embed_model_link(application, model, item, parent_item)
    send("destroy_embed_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", item, {parent_id: parent_item.id.to_s})
  end

  def model_template(application, model, action)
    template = "my_admin/#{application.key}/#{model.model_tableize}/#{action}"
    template = "my_admin/#{application.key}/models/#{action}" if !lookup_context.exists? template, [], true and !lookup_context.exists? template, [], false
    template = "my_admin/models/#{action}" if !lookup_context.exists? template, [], true and !lookup_context.exists? template, [], false
    template
  end

end
