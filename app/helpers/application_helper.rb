# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Custom Button function to work as AJAX link_to_remote
  def button_to_remote name, options = {}
    button_to_function name, remote_function(options)
  end
  
  # function used to show thumb images on all views
  
  def thumb_for photo   
    url = thumb_photo_url(:plan_id => photo.plan_id, :id => photo)    
    image = image_tag(url, :class => "thumb", :alt => "")    
    link_to_function image, nil, :class => "show" do |page|
      page.photo.show full_photo_url(:plan_id => photo.plan_id, :id => photo)
    end    
    #debugger if ENV['RAILS_ENV'] == 'development'
  end 
  
  def isMD
    return @session['user'].category.eql?("MD")
    # return true
  end 
end
