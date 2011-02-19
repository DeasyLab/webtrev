class ReviewsController < ApplicationController
  scaffold    :review
  before_filter :login_required
  before_filter :find_plan
  
  def transverse
    session['dvh_displayed']= Array.new;
    session['dvh_id']= Array.new;
    session['view'] = 'tra';        
    if !params['transverse'].nil?
      find_plan
      session['tra_structOnSlc']= params['transverse']['struct'].to_i;
      # debugger if ENV['RAILS_ENV'] == 'development'  
      if params['transverse']['struct'].to_i == 0
        @allTransURL = Review.find_photo(@plan.id,'tra')         
      else
        # debugger if ENV['RAILS_ENV'] == 'development'
        @allTransURL = Review.find_structonslice(@plan.id,'tra',params['transverse']['struct'].to_i)       
      end
    else
      # debugger if ENV['RAILS_ENV'] == 'development'
      @allTransURL = Review.find_photo(@plan.id,'tra')         
    end
    
    if request.xml_http_request?
      render :action => "transverse"
    end       
  end
  
  def coronal
    session['view'] = 'cor';    
    # debugger if ENV['RAILS_ENV'] == 'development'
    session['dvh_displayed']= Array.new;
    session['dvh_id']= Array.new;
    if !params['coronal'].nil?
      find_plan
      session['cor_structOnSlc']= params['coronal']['struct'].to_i;
      # debugger if ENV['RAILS_ENV'] == 'development'  
      if params['coronal']['struct'].to_i == 0
        @allCoronalURL = Review.find_photo(@plan.id,'cor')         
      else
        # debugger if ENV['RAILS_ENV'] == 'development'
        @allCoronalURL = Review.find_structonslice(@plan.id,'cor',params['coronal']['struct'].to_i)       
      end
    else
      @allCoronalURL = Review.find_photo(@plan.id,'cor')
    end
    
    if request.xml_http_request?
      render :action => "coronal"
    end   
  end
  
  def sagittal
    session['view'] = 'sag';    
    # debugger if ENV['RAILS_ENV'] == 'development'
    session['dvh_displayed']= Array.new;
    session['dvh_id']= Array.new;
    
    @allSagittalURL = Review.find_photo(@plan.id,'sag')
    
    if !params['sagittal'].nil?
      find_plan
      session['sag_structOnSlc']= params['sagittal']['struct'].to_i;
      # debugger if ENV['RAILS_ENV'] == 'development'  
      if params['sagittal']['struct'].to_i == 0
        @allSagittalURL = Review.find_photo(@plan.id,'sag')         
      else
        # debugger if ENV['RAILS_ENV'] == 'development'
        @allSagittalURL = Review.find_structonslice(@plan.id,'sag',params['sagittal']['struct'].to_i)       
      end
    else
      @allSagittalURL = Review.find_photo(@plan.id,'sag')
    end
    
    if request.xml_http_request?
      render :action => "sagittal"
    end  
  end
  
  def dvh
    session['view'] = 'dvh';    
    session['dvh_displayed']= Array.new;
    session['dvh_id']= Array.new;
    # debugger if ENV['RAILS_ENV'] == 'development'
    @allDVHURL = Review.find_photo(@plan.id,'dvh')
  end
  
  
  def target
    session['view'] = 'target';    
    
    if !params['target'].nil?
      find_plan
      session['target_structOnSlc']= params['target']['struct'].to_i;
      # debugger if ENV['RAILS_ENV'] == 'development'  
      if params['target']['struct'].to_i == 0
        @alltargetURL = Review.find_photo(0,'target')         
      else
        #debugger if ENV['RAILS_ENV'] == 'development'
        @alltargetURL = Review.find_structonslice(@plan.id,'target',params['target']['struct'].to_i)       
      end
    else
      @alltargetURL = Review.find_photo(0,'target')         
    end
    
    if request.xml_http_request?
      render :action => "target"
    end       
  end
  
  def dvhstat
    if session['view'].eql?('dvh')
#      debugger if ENV['RAILS_ENV'] == 'development'
      @dvhstat = Dvhstat.find_by_review_id(params[:review_id]);
      render :partial => 'dvhstat'
    else
      render :partial => 'dummy'
    end
  end
  
  def showDVH1    
    @dvh_url = full_photo_url(:plan_id => session['plan']['id'], :id => @params['dvh'])    
#    debugger if ENV['RAILS_ENV'] == 'development'
    session['dvh_displayed'][0] = Dvhstat.structName_by_review_id(@params['dvh'])[0].structName;
    session['dvh_id'][0] = @params['dvh'];    
    render :partial => 'showdvh1'
  end
  
  def showDVH2    
    @dvh_url = full_photo_url(:plan_id => session['plan']['id'], :id => @params['dvh'])    
    session['dvh_displayed'][1] =  Dvhstat.structName_by_review_id(@params['dvh'])[0].structName;
    session['dvh_id'][1] = @params['dvh'];
    render :partial => 'showdvh2'
  end
  
  def showDVH3    
    @dvh_url = full_photo_url(:plan_id => session['plan']['id'], :id => @params['dvh'])    
    session['dvh_displayed'][2] =  Dvhstat.structName_by_review_id(@params['dvh'])[0].structName;
    session['dvh_id'][2] = @params['dvh'];
    render :partial => 'showdvh3'
  end
  
  def showDVH4    
    @dvh_url = full_photo_url(:plan_id => session['plan']['id'], :id => @params['dvh'])    
    session['dvh_displayed'][3] =  Dvhstat.structName_by_review_id(@params['dvh'])[0].structName;
    session['dvh_id'][3] = @params['dvh'];
    render :partial => 'showdvh4'
  end
  
  def structLegend
    if session['view'].eql?('tra') | session['view'].eql?('cor') | session['view'].eql?('sag')
      # debugger if ENV['RAILS_ENV'] == 'development'
      #@dvhstat = Dvhstat.find_by_review_id(params[:review_id]);
      
      @structLegend = Review.find_structonslice_all(@plan.id,params[:review_id])
      
      render :partial => 'structLegend'
    else
      render :partial => 'dummy'
    end
  end
  
  def allcomments
    session['view']= 'comments';    
    #    debugger if ENV['RAILS_ENV'] == 'development'
    @allReview_id = Review.find(:all,:select=>"id, plan_id, coord, view_type", :from=>"reviews", :conditions=>["plan_id = ?", "#{@plan.id}"]);    
  end
  
  
  %w(full thumb).each do |size|
    class_eval <<-END
      expire_page :image      
      def #{size}
        find_photo;        
        send_data @photo.image, :filename => "\#{@photo.id}.#{size}.png", :type => 'image/png', :disposition => 'inline';        
      end
      caches_page :image
    END
    
  end
  
  # Private mathods for review controller    
  private  
  def find_plan ( )  @plan = session['plan']; end    
end