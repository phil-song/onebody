ActionController::Routing::Routes.draw do |map|
  
  PHOTO_SIZE_METHODS = {:tn => :get, :small => :get, :medium => :get, :large => :get}

  map.connect '', :controller => 'people'
  
  map.resource :account, :member => {:verify_code => :any, :select => :any}
  
  map.resources :people do |people|
    people.resources :groups
    people.resources :pictures
    people.resources :friends, :collection => {:reorder => :post}
    people.resources :remote_accounts, :member => {:sync => :post}
    people.resource :account, :member => {:verify_code => :any, :select => :any}
    people.resource :sync
    people.resource :privacy
    people.resource :blog
    people.resource :wall, :member => {:with => :get}
    people.resource :photo, :member => PHOTO_SIZE_METHODS
  end
  
  map.resources :families do |families|
    families.resource :photo, :member => PHOTO_SIZE_METHODS
  end
  
  map.resources :groups do |groups|
    groups.resources :memberships, :collection => {:batch => :any}
    groups.resources :notes
    groups.resources :messages
    groups.resources :prayer_requests
    groups.resource :photo, :member => PHOTO_SIZE_METHODS
  end
  
  map.resources :albums do |albums|
    albums.resources :pictures, :member => {:next => :get, :prev => :get} do |pictures|
      pictures.resource :photo, :member => PHOTO_SIZE_METHODS
    end
  end
 
  map.resources :recipes do |recipes|
    recipes.resource :photo, :member => PHOTO_SIZE_METHODS
  end

  map.resources :messages do |messages|
    messages.resources :attachments
  end
  
  map.resources :verses
  map.resources :publications
  map.resources :notes
  map.resources :shares
  map.resources :tags
  map.resources :news
  map.resources :comments

  map.resource :session
  map.resource :search, :member => {:opensearch => :get}
  map.resource :printable_directory
  map.resource :feed
  map.resource :privacy
  
  # here there be dragons

  map.with_options :controller => 'setup/dashboard' do |m|
    m.setup 'setup', :action => 'index'
    m.setup_not_authorized 'setup/not_local_or_secret_not_given', :action => 'not_local_or_secret_not_given'
    m.setup_authorize_ip 'setup/authorize_ip', :action => 'authorize_ip'
    m.setup_change_environment 'setup/change_environment', :action => 'change_environment'
    m.setup_environment 'setup/environment', :action => 'environment'
    m.not_local_or_secret_not_given 'setup/not_local_or_secret_not_given', :action => 'not_local_or_secret_not_given'
  end

  map.with_options :controller => 'setup/sites' do |m|
    m.setup_sites 'setup/sites', :action => 'index'
    m.setup_edit_multisite 'setup/sites/edit_multisite', :action => 'edit_multisite'
    m.setup_edit_site 'setup/sites/edit', :action => 'edit'
    m.setup_delete_site 'setup/sites/delete', :action => 'delete'
  end

  map.with_options :controller => 'setup/database' do |m|
    m.setup_database 'setup/database', :action => 'index'
    m.setup_load_fixtures 'setup/database/load_fixtures', :action => 'load_fixtures'
    m.setup_migrate_database 'setup/database/migrate', :action => 'migrate'
    m.setup_edit_database 'setup/database/edit', :action => 'edit'
    m.setup_backup_database 'setup/database/backup', :action => 'backup'
  end

  map.with_options :controller => 'setup/settings' do |m|
    m.setup_edit_settings 'setup/settings/edit/:id', :action => 'edit'
    m.setup_global_settings 'setup/settings/global', :action => 'global'
    m.setup_settings 'setup/settings/:id', :action => 'view'
  end
  
  map.with_options :controller => 'administration/dashboard' do |m|
    m.admin 'administration/dashboard', :action => 'index'
    m.admin_log 'administration/dashboard/log', :action => 'log'
    m.admin_updates 'administration/dashboard/updates', :action => 'updates'
    m.remove_admin 'administration/dashboard/remove_admin', :action => 'remove_admin'
    m.edit_attribute 'administration/dashboard/edit_attribute', :action => 'edit_attribute'
    m.add_admin 'administration/dashboard/add_admin', :action => 'add_admin'
    m.admin_membership_requests 'administration/dashboard/admin_membership_requests', :action => 'admin_membership_requests'
    m.mark_reviewed 'administration/dashboard/mark_reviewed', :action => 'mark_reviewed'
    m.admin_toggle_complete 'administration/dashboard/toggle_complete', :action => 'toggle_complete'
    m.admin_delete_update 'administration/dashboard/delete_update', :action => 'delete_update'
  end

  map.with_options :controller => 'administration/settings' do |m|
    m.settings 'administration/settings', :action => 'index'
    m.edit_settings 'administration/settings/edit/:id', :action => 'edit'
  end

  map.with_options :controller => 'checkin/admin' do |m|
    # FIXME: cannot get next route to work minus "index" on the end - clashes with checkin_section route
    m.checkin_admin 'checkin/admin/index', :action => 'index'
    m.checkin_report 'checkin/admin/report', :action => 'report'
  end
  
  map.with_options :controller => 'checkin' do |m|
    m.checkin 'checkin', :action => 'index'
    m.checkin_date_and_time 'checkin/date_and_time', :action => 'date_and_time'
    m.report_date_and_time 'checkin/report_date_and_time', :action => 'report_date_and_time'
    m.checkin_section 'checkin/:section', :action => 'section'
    m.check 'checkin/:section/check', :action => 'check'
    m.checkin_attendance 'checkin/:section/attendance', :action => 'attendance'
    m.void_attendance_record 'checkin/:section/void', :action => 'void'
  end
  
  map.with_options :controller => 'help' do |m|
    m.help 'help', :action => 'index'
    m.privacy_policy 'help/privacy_policy', :action => 'privacy_policy'
    m.unauthorized 'help/unauthorized', :action => 'unauthorized'
    m.bad_status 'help/bad_status', :action => 'bad_status'
    m.safeguarding_children 'help/safeguarding_children', :action => 'safeguarding_children'
    m.credits 'help/credits', :action => 'credits'
  end
end
