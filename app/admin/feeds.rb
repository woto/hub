ActiveAdmin.register Feed do
  preserve_default_filters!
  remove_filter :feed_categories

  index do
    column :file_full_path
    column :categories_count
    column :offers_count
    active_admin_config.resource_columns.each do |attribute|
      column attribute
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :advertiser_id, :ext_id, :name, :url, :locked_by_pid, :last_error, :last_attempt_uuid, :processing_started_at, :processing_finished_at, :data, :last_synced_at, :network_updated_at, :advertiser_updated_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:advertiser_id, :ext_id, :name, :url, :locked_by_pid, :last_error, :last_attempt_uuid, :processing_started_at, :processing_finished_at, :data, :last_synced_at, :network_updated_at, :advertiser_updated_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
