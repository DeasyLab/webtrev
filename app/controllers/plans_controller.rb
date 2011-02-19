class PlansController < ApplicationController
  scaffold      :plan    
    before_filter :login_required
    before_filter :get_user
  
  def unapproved		
    plans_per_page = 5
    
    sort = case params['sort']
      when "Plan ID"       then "tx_plan_id"
      when "Last Name"     then "last_name"
      when "First Name"    then "first_name"
      when "Date Created"  then "created_at"
      when "Date Approved" then "approved_at"
      when "Planner"       then "planner"
      when "Planning System" then "tx_plan_system"
      when "Status"        then "plan_status"
      
      when "Plan ID_reverse"       then "tx_plan_id DESC"
      when "Last Name_reverse"     then "last_name DESC"
      when "First Name_reverse"    then "first_name DESC"
      when "Date Created_reverse"  then "created_at DESC"
      when "Date Approved_reverse" then "approved_at DESC"
      when "Planner_reverse"       then "planner DESC"
      when "Planning System_reverse" then "tx_plan_system DESC"
      when "Status_reverse"        then "plan_status DESC"           
    end 
    
    # debugger if ENV['RAILS_ENV'] == 'development'
    
    if sort.nil?
      sort = "created_at DESC"
    end
    
    if isMD
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND user_id = ? AND plan_status = ? AND send_review = ?", "%#{params[:queryLM]}%", "#{@user.id}", "unapproved", "1"] 
      else     
        conditions = ["user_id = ? AND plan_status = ? AND send_review = ?", "#{@user.id}", "unapproved", "1"] 
      end   
    else
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND creator_id = ? AND plan_status = ?", "%#{params[:queryLM]}%", "#{@user.id}", "unapproved"] 
      else     
        conditions = ["creator_id = ? AND plan_status = ?", "#{@user.id}", "unapproved"] 
      end   
    end     
    
    # debugger if ENV['RAILS_ENV'] == 'development'
    
    session['planType'] = 'unapproved'
    
    @planType = 'unapproved'
    
    @total = Plan.count(:conditions => conditions)
    
    @plans_pages, @plans = paginate :plans, :order => sort, :conditions => conditions, :per_page => plans_per_page
    
    if request.xml_http_request?
      render :partial => "plan_list", :layout => false
    end
  end
  
  def all
    plans_per_page = 5
    
    sort = case params['sort']
      when "Plan ID"       then "tx_plan_id"
      when "Last Name"     then "last_name"
      when "First Name"    then "first_name"
      when "Date Created"  then "created_at"
      when "Date Approved" then "approved_at"
      when "Planner"       then "planner"
      when "Planning System" then "tx_plan_system"
      when "Status"        then "plan_status"
      
      when "Plan ID_reverse"       then "tx_plan_id DESC"
      when "Last Name_reverse"     then "last_name DESC"
      when "First Name_reverse"    then "first_name DESC"
      when "Date Created_reverse"  then "created_at DESC"
      when "Date Approved_reverse" then "approved_at DESC"
      when "Planner_reverse"       then "planner DESC"
      when "Planning System_reverse" then "tx_plan_system DESC"
      when "Status_reverse"        then "plan_status DESC"           
    end 
    
    
    if sort.nil?
      sort = "created_at DESC"
    end
    
    if isMD
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND user_id = ? ", "%#{params[:queryLM]}%", "#{@user.id}"] 
      else     
        conditions = ["user_id = ?", "#{@user.id}"] 
      end
    else
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND creator_id = ? ", "%#{params[:queryLM]}%", "#{@user.id}"] 
      else     
        conditions = ["creator_id = ?", "#{@user.id}"] 
      end
      
    end
    
    session['planType'] = 'all'
    
    @planType = 'all'
    
    @total = Plan.count(:conditions => conditions)
    
    @plans_pages, @plans = paginate :plans, :order => sort, :conditions => conditions, :per_page => plans_per_page
    
    if request.xml_http_request?
      render :partial => "plan_list", :layout => false
    end
    
  end
  
  def assigned
    plans_per_page = 10
    
    sort = case params['sort']
      when "Plan ID"       then "tx_plan_id"
      when "Last Name"     then "last_name"
      when "First Name"    then "first_name"
      when "Date Created"  then "created_at"
      when "Date Approved" then "approved_at"
      when "Planner"       then "planner"
      when "Planning System" then "tx_plan_system"
      when "Status"        then "plan_status"
      
      when "Plan ID_reverse"       then "tx_plan_id DESC"
      when "Last Name_reverse"     then "last_name DESC"
      when "First Name_reverse"    then "first_name DESC"
      when "Date Created_reverse"  then "created_at DESC"
      when "Date Approved_reverse" then "approved_at DESC"
      when "Planner_reverse"       then "planner DESC"
      when "Planning System_reverse" then "tx_plan_system DESC"
      when "Status_reverse"        then "plan_status DESC"           
    end 
    
    if sort.nil?
      sort = "created_at DESC"
    end
    
    allPlansID = Assignplan.find(:all, :conditions => ["user_id = ?",  "#{@user.id}"])
    
    id = ''
    
    allPlansID.each do |planID|
      if planID.eql? allPlansID.last
        
        #        debugger if ENV['RAILS_ENV'] == 'development'
        
        id = id + ' id = ' + planID.plan_id.to_s
        
      else
        id = id + ' id = ' + planID.plan_id.to_s + ' OR'
        
      end      
    end                
    
    if !params[:queryLM].nil?
      conditions = ["last_name LIKE %#{params[:queryLM]}% AND " + id] 
    else     
      conditions = [id] 
    end
    
    #~ debugger if ENV['RAILS_ENV'] == 'development'
    
    session['planType'] = 'assigned'
    
    @planType = 'approved'
    
    @total = Plan.count(:conditions => conditions)
    
    @plans_pages, @plans = paginate :plans, :order => sort, :conditions => conditions, :per_page => plans_per_page
    
    if request.xml_http_request?
      render :partial => "plan_list", :layout => false
    end
  end
  
  def approved
    plans_per_page = 5
    
    sort = case params['sort']
      when "Plan ID"       then "tx_plan_id"
      when "Last Name"     then "last_name"
      when "First Name"    then "first_name"
      when "Date Created"  then "created_at"
      when "Date Approved" then "approved_at"
      when "Planner"       then "planner"
      when "Planning System" then "tx_plan_system"
      when "Status"        then "plan_status"
      
      when "Plan ID_reverse"       then "tx_plan_id DESC"
      when "Last Name_reverse"     then "last_name DESC"
      when "First Name_reverse"    then "first_name DESC"
      when "Date Created_reverse"  then "created_at DESC"
      when "Date Approved_reverse" then "approved_at DESC"
      when "Planner_reverse"       then "planner DESC"
      when "Planning System_reverse" then "tx_plan_system DESC"
      when "Status_reverse"        then "plan_status DESC"           
    end 
    
    if sort.nil?
      sort = "created_at DESC"
    end
    
    if isMD          
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND user_id = ? AND plan_status = ?", "%#{params[:queryLM]}%", "#{@user.id}", "approved"] 
      else     
        conditions = ["user_id = ? AND plan_status = ?", "#{@user.id}", "approved"] 
      end
    else
      if !params[:queryLM].nil?
        conditions = ["last_name LIKE ? AND creator_id = ? AND plan_status = ?", "%#{params[:queryLM]}%", "#{@user.id}", "approved"] 
      else     
        conditions = ["creator_id = ? AND plan_status = ?", "#{@user.id}", "approved"] 
      end
    end
    
    session['planType'] = 'approved'
    
    @planType = 'approved'
    
    @total = Plan.count(:conditions => conditions)
    
    @plans_pages, @plans = paginate :plans, :order => sort, :conditions => conditions, :per_page => plans_per_page
    
    if request.xml_http_request?
      render :partial => "plan_list", :layout => false
    end
  end
  
  def approve  
    #    debugger if ENV['RAILS_ENV'] == 'development'
    @plan = Plan.find(params[:id])
    @plan.update_attribute("plan_status", "approved")
    @plan.update_attribute("approved_at", Time.now())
    #    render :update do |page|
    #      page["#{@plan.id}"].fade()
    #    end      
    #    debugger if ENV['RAILS_ENV'] == 'development'
    redirect_to :action => "unapproved"
  end
  
  def send_review
    @plan = Plan.find(params[:id])
    @plan.update_attribute("send_review", "1")   
    Plan.belongs_to(:user)
    
    user = User.find_by_id("1");
    #    Notifier.deliver_review_plan(user);    
    #
    #    debugger if ENV['RAILS_ENV'] == 'development'    
    redirect_to :action => "#{session['planType']}"
  end
  
  
  def review
    session['view'] = 'tra';
    session['plan'] = Plan.find(params[:id])
    redirect_to :controller=>"reviews", :action => "transverse"
  end
  
  def launchOQA    
    session['view'] = 'tra';
    session['plan'] = Plan.find_by_tx_plan_id(params['tx_plan_id'])
    redirect_to :controller=>"reviews", :action => "transverse"        
  end
  
  private
  def get_user() @user = session['user']; end    
  
  #  def sendEMail()
  #    
  #  end
  
  def isMD
    return session['user'].category.eql?("MD")
  end 
end
