class ProcessplansController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def process_list
    @session['planType'] = 'process_list'
    
    items_per_page = 10
    
    sort = case @params['sort']
      when "Plan"       then "archive"
      when "Lastname"  then "patientname_last"
      when "Firstname" then "patientname_first"        
      when "datecreated" then "datecreated"
      when "Plan_reverse"       then "archive DESC"
      when "Lastname_reverse"  then "patientname_last DESC"
      when "Firstname_reverse" then "patientname_first DESC"     
      when "datecreated_reverse" then "datecreated DESC"        
    end
    
    # debugger if ENV['RAILS_ENV'] == 'development'      
    if sort.nil?
      sort = "datecreated DESC"
    end
    
    
    if @params[:queryPP].nil?
      conditions = ["patientname_first LIKE ? AND processed = ? AND inqueue = ?", "%#{@params[:queryPP]}%" , "0", "0"]
    else
      conditions = ["processed = ? AND inqueue = ?", "0", "0"] 
    end
    
    # conditions = ["patientname_first LIKE ?", "%#{@params[:queryPP]}%"] unless @params[:queryPP].nil?
    
    #    debugger if ENV['RAILS_ENV'] == 'development' 
    
    @total = Processplan.count(:conditions => conditions)      
    
    @processplan_pages, @processplans = paginate :processplans, :order => sort, :conditions => conditions, :per_page => items_per_page
    
    if request.xml_http_request?
      render :partial => "processplans_list", :layout => false   
    end      
    
  end     
  
  def processed_list
    @session['planType'] = 'processed_list'
    
    items_per_page = 10
    
    sort = case @params['sort']
      when "Plan"       then "archive"
      when "Lastname"  then "patientname_last"
      when "Firstname" then "patientname_first"        
      when "datecreated" then "datecreated"
      when "Plan_reverse"       then "archive DESC"
      when "Lastname_reverse"  then "patientname_last DESC"
      when "Firstname_reverse" then "patientname_first DESC"     
      when "datecreated_reverse" then "datecreated DESC"        
    end
    
    # debugger if ENV['RAILS_ENV'] == 'development'      
    if sort.nil?
      sort = "datecreated DESC"
    end
    
    # Processplan.has_many(:alldose)
    
    if @params[:queryPP].nil?
      conditions = ["patientname_first LIKE ? AND processed = ? AND inqueue = ?", "%#{@params[:queryPP]}%" , "1", "0"]
    else
      conditions = ["processed = ? AND inqueue = ?", "1", "0"] 
    end
    
    # conditions = ["patientname_first LIKE ?", "%#{@params[:queryPP]}%"] unless @params[:queryPP].nil?
    
    @total = Processplan.count(:conditions => conditions)      
    
    @processplan_pages, @processplans = paginate :processplans, :order => sort, :conditions => conditions, :per_page => items_per_page
    
    if request.xml_http_request?
      render :partial => "processplans_list", :layout => false
    end      
  end   
  
  
  def inqueue_list
    
    @session['planType'] = 'inqueue_list'
    
    items_per_page = 10
    
    sort = case @params['sort']
      when "Plan"       then "archive"
      when "Lastname"  then "patientname_last"
      when "Firstname" then "patientname_first"        
      when "datecreated" then "datecreated"
      when "Plan_reverse"       then "archive DESC"
      when "Lastname_reverse"  then "patientname_last DESC"
      when "Firstname_reverse" then "patientname_first DESC"     
      when "datecreated_reverse" then "datecreated DESC"        
    end
    
    # debugger if ENV['RAILS_ENV'] == 'development'      
    if sort.nil?
      sort = "datecreated DESC"
    end
    
    # Processplan.has_many(:alldose)
    
    if @params[:queryPP].nil?
      conditions = ["patientname_first LIKE ? AND inqueue = ?", "%#{@params[:queryPP]}%", "1"]
    else
      conditions = ["inqueue = ?", "1"] 
    end
    
    # conditions = ["patientname_first LIKE ?", "%#{@params[:queryPP]}%"] unless @params[:queryPP].nil?
    
    @total = Processplan.count(:conditions => conditions)      
    
    @processplan_pages, @processplans = paginate :processplans, :order => sort, :conditions => conditions, :per_page => items_per_page
    
    if request.xml_http_request?
      render :partial => "processplans_list", :layout => false
    end      
  end 
  
  #  def gotoparams
  #    case @request.method
  #    when :post
  #      @session['processplan_id'] = params[:id];     
  #      
  #      @processplan = Processplan.find(params[:id]);
  #      
  #      @session['processplan_name'] = @processplan.archive
  #      
  #      redirect_to :controller=>"inplanparams", :action => "list"      
  #    end
  #  end
  
  #  def uploadFile # Upload Pinnacle Report File
  #    
  #    render :text => "File has been uploaded successfully"
  #  end
  
  def cleanup # Delete Pinnacle Report File
    File.delete("#{RAILS_ROOT}/dirname/#{@filename}") 
    if File.exist?("#{RAILS_ROOT}/dirname/#{@filename}")
    end
  end
  
  
  def show
    @processplan = Processplan.find(params[:id])
  end
  
  def new
    @processplan = Processplan.new
  end
  
  def create
    @processplan = Processplan.new(params[:processplan])
    if @processplan.save
      flash[:notice] = 'Processplan was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def sendtoqueue
    @processplan = Processplan.find(params[:plan_id].to_i)
    
    Processplan.has_many(:inplanparam)
    
    @processplan.update_attribute("inqueue", "1");
    @processplan.update_attribute("creator_id", session['user']['id'].to_i);
    @processplan.update_attribute("ref_phy_id", params[:userSelect].to_i);
    @processplan.update_attribute("dose_id", params[:doseSelect].to_i);
    
    @processplan.update_attribute("preset", params[:presetSelect]);
    
    #    @processplan.update_attribute("", "");
    #    @processplan.update_attribute("", "");           
    #    debugger if ENV['RAILS_ENV'] == 'development'      
    
    Processplan.save(params[:upload])
    
#    debugger if ENV['RAILS_ENV'] == 'development'
    
    @filename =  @params['upload']['datafile'].original_filename;
    
    @processplan.update_attribute("report_upload", @filename);
    
    redirect_to :action => "process_list"      
  end
  
  
  def re_send_process
    
  end
  
  
  def reportGeneration
    @userAll = User.getMD(nil);
  end
  
  def addselectedparams
    
    @allstruct = Allstruct.allstructName(@session['processplan_id'])
    
    allItems = @params['struct_id']
    
    @struct_id = nil 
    
    @standardreport = nil
    
    i = 0
    allItems.each { |item|
      i = i + 1            
      
      if (item[1].to_s.to_i != 0) then
        
        @struct_id = item[0].to_s.to_i        
        @standardreport = Standardreport.find(@struct_id)        
        toUse = nil
        
        @allstruct.each{ |struct|           
          
          if struct['structurename'].to_s.gsub(' ', '').downcase == @standardreport.structure.gsub(' ', '').downcase
            toUse = @standardreport            
            break
          end                    
        }
        
        if !toUse.nil?
          @inplanparam = Inplanparam.new          
          
          @inplanparam['processplan_id']  = @session['processplan_id']
          @inplanparam['structure']       = toUse['structure']
          @inplanparam['metric']          = toUse['metric']
          @inplanparam['category']        = toUse['category']         
          
          if @inplanparam.save                 
            
            standardreport_id = toUse['id'];
            
            # debugger if ENV['RAILS_ENV'] == 'development'      
            
            conditions = ["standardreport_id = ?", "#{standardreport_id}"]
            
            case toUse['metric']
              
              when "Dx"
              @dxmetric = Dxmetric.find(:first, :conditions => condition)      
              
              @dxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i
              
              @dxmetric.standardreport_id = [];
              
              @dxmetric.id = [];
              
              @dxmetric = Dxmetric.new(@dxmetric)
              
              @dxmetric.save        
              
              when "Vx"             
              @vxmetric = Vxmetric.new(:first, :conditions => condition)
              
              @vxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
              
              @vxmetric.standardreport_id = [];
              
              @vxmetric.id = [];
              
              @vxmetric = Vxmetric.new(@vxmetric)
              
              @vxmetric.save
              
              when "maxDose"        
              @maxdosemetric = Maxdosemetric.new(params[:maxdosemetric])
              
              @maxdosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
              
              @maxdosemetric.standardreport_id = [];
              
              @maxdosemetric.id = [];
              
              @maxdosemetric = Maxdosemetric.new(@maxdosemetric)
              
              @maxdosemetric.save
              
              when "meanDose"       
              @meandosemetric = Meandosemetric.new(params[:meandosemetric])
              
              @meandosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
              
              @meandosemetric.standardreport_id = [];
              
              @meandosemetric = Meandosemetric.new(@meandosemetric)
              
              @meandosemetric.id = [];
              
              @meandosemetric.save        
              
              when "minDose"        
              @mindosemetric = Mindosemetric.new(params[:mindosemetric])
              
              @mindosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
              
              @mindosemetric.standardreport_id = [];
              
              @mindosemetric.id = [];
              
              @mindosemetric = Mindosemetric.new(@mindosemetric)
              
              @mindosemetric.save        
              
              when "Manual"         
              
            end                    
          end
        end
      end  
    }
    redirect_to :controller=>"inplanparams", :action => "list"      
  end
  
  def showReportTypes
    conditions = ["user_id = ?", @params['lastname'].to_i]
    
    @total = Standardreporttype.count(:conditions => conditions)  
    
    @standardreporttypes = Standardreporttype.find(:all,:conditions => conditions)  
    
    render :partial => "showReportTypes", :layout => false
  end
  
  
  def edit
    @processplan = Processplan.find(params[:id])
  end
  
  def update
    @processplan = Processplan.find(params[:id])
    if @processplan.update_attributes(params[:processplan])
      flash[:notice] = 'Processplan was successfully updated.'
      redirect_to :action => 'show', :id => @processplan
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Processplan.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

