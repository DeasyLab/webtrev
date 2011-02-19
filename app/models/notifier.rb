class Notifier < ActionMailer::Base

def review_plan( user )
  # Email header info MUST be added here
  recipients user.login
  from  "dkhullar@wustl.edu"
  subject "WEBTREV Plan Ready"
  
  debugger if ENV['RAILS_ENV'] == 'development'    
  
  # Email body substitutions go here
  body :first_name => user.firstname, :last_name => user.lastname
end

end
