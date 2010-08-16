class ImportMailer < Mailer

  # Builds a tmail object used to email recipients of the added issue.
  #
  # Example:
  #   email_import_failed(email_from_customer) => tmail object
  #   ImportMailer.deliver_email_import_failed(email_from_customer) => sends an email to mail sender
  def email_import_failed(email_from_customer)
  
    sender_email = email_from_customer.from.to_a.first.to_s.strip
    applify_email = 'mail@applify.com'
    
    recipients([sender_email, applify_email])
    subject "Applify Issue tracker: Unable to process your request"
    body  :orig_email => sender_email,
          :orig_subject => email_from_customer.subject
    render_multipart('email_import_failed', body)
  end
end