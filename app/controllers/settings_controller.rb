class SettingsController < ApplicationController
  
  before_filter :login_required
  
  def list    
  end
  
   def installation
    render :partial => "installation"
  end
end
