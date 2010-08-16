require 'redmine'

require_dependency 'mail_handler'
require 'mail_handler_extension'

Redmine::Plugin.register :redmine_stealth do

  name        'Email Import'
  author      'Adrian Herzog, Applify'
  description 'Assign unknown email addresses to users and projects'
  version     '0.1.0'

  permission :email_assignment, {:email_assignment => [:index, :edit]}, :public => true
  menu :project_menu, :email_assignment, { :controller => 'email_assignment', :action => 'index' }, :caption => 'Email', :after => :settings, :param => :project_id
  
end
