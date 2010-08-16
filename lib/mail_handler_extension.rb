class MailHandler
  
  def receive_with_patch(email)
    
    sender_email = email.from.to_a.first.to_s.strip
    sender_email_domain = '*@' + sender_email.split('@')[1]
    
    # 1. Step: Find out whether the user exists as an active redmine user account.
    # If this is the case, no further action is taken, as the default
    # mail importer will be able to assign the issue to the existing user.
    users = User.find(:all, :conditions => {:mail => sender_email, :status => 1})
    if(users.length > 0)
      return receive_without_patch(email)
    end
    
    # 2. Step: Find out whether there exists an assignment for the senders
    # email address or for its domain. Domain assignments are only used
    # if there exists no specific entry for the given email address.
    assignments = EmailAssignment.find(:all, 
      :conditions => {:email => [sender_email, sender_email_domain]}, 
      :order => 'email DESC')
      
    if(assignments.length > 0)
      user = assignments[0].user
      if user
        email.from = user.mail
      end
      
      project = assignments[0].project
      if project
        @@handler_options[:issue][:project] = project.identifier
      end
    end
    
    result = receive_without_patch(email)
    
    # Send email, if import failed
    if !result
      ImportMailer.deliver_email_import_failed(email)
    end
    
    result
  end
  
  alias_method_chain :receive, :patch
end