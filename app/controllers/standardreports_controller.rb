class StandardreportsController < ApplicationController
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list  
    items_per_page = 10
    
    sort = case @params['sort']
    when "Structure"  then "structure"
    when "Category"   then "category"        
      
    when "Structure_reverse"  then "structure DESC"
    when "Category_reverse"   then "category DESC"         
    end
    
    if @params['reportName'].nil?
      @params['reportName'] = @session['reporttype_id'].to_s
    end
    
    if @params['reportName'].upcase.eql? 'PLEASE SELECT'      
      render :partial => "blank", :layout => false
      
    else
      @session['reporttype_id'] = @params['reportName'].to_i
      
      
      if !@params['structName'].nil?
        conditions = ["structure LIKE ? AND standardreporttype_id = ?", "%#{@params[structName]}%", @session['reporttype_id']]      
      else
        conditions = ["standardreporttype_id = ?", @session['reporttype_id']]
      end
      
      #    debugger if ENV['RAILS_ENV'] == 'development'
      
      @total = Standardreport.count(:conditions => conditions)
      
      @standardreports_pages, @standardreports = paginate :standardreports, :order => sort, :conditions => conditions, :per_page => items_per_page
      
      if request.xml_http_request?
        render :partial => "list", :layout => false
      else
        render :partial => "list", :layout => false
      end      
    end
  end     
  
  def show
    @standardreports = Standardreport.find(params[:id])
  end
  
  def new
    #    debugger if ENV['RAILS_ENV'] == 'development' 
    @standardreports = Standardreport.new
    render :partial => "new", :layout => false
  end
  
  def create
    @standardreports = Standardreport.new(params[:standardreports])
    @standardreports.standardreporttype_id = @session['reporttype_id'].to_i
    if @standardreports.save
      redirect_to :action => 'list' 
    else
      render :action => 'new'
    end
  end
  
  def edit
    @standardreports = Standardreport.find(params[:id])
    render :partial => 'edit'
  end
  
  def update
    @standardreports = Standardreport.find(params[:id])
    if @standardreports.update_attributes(params[:standardreports])
      #      flash[:notice] = 'Standardreports was successfully updated.'
      redirect_to :action => 'list', :id => @standardreports
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Standardreport.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  ###################################################################################################  
  ###################################################################################################
  ####################################################################################################
  ####################################################################################################
  
  def dispmetric
    
    #    debugger if ENV['RAILS_ENV'] == 'development' 
    
    case @params[:standardreport_metric]
      
    when "Select Metric"
      render :partial => "dispmetric", :layout => false  
      
    when "Dx"
      @dxmetric = Dxmetric.new
      render :partial => "dx", :layout => false  
      
    when "Vx"             
      @Vx = Vxmetric.new
      render :partial => "vx", :layout => false  
      
    when "maxDose"        
      @maxDose= Maxdosemetric.new
      render :partial => "maxDose", :layout => false  
      
    when "meanDose"       
      @meanDose = Meandosemetric.new
      render :partial => "meanDose", :layout => false  
      
    when "minDose"        
      @minDose = Mindosemetric.new
      render :partial => "minDose", :layout => false  
      
    when "Manual"         
      @standardreport = Standardreport.new
      render :partial => "new", :layout => false  
    end        
    
  end
  
  def updatemetrics
    
    #    debugger if ENV['RAILS_ENV'] == 'development' 
    
    @standardreport = Standardreport.new(@params[:standardreport]);
    
    @standardreport.standardreporttype_id = @session['reporttype_id']        
    
    #    debugger if ENV['RAILS_ENV'] == 'development' 
    
    if @standardreport.save
      Standardreport.belongs_to(:processplan)
      
      case @params[:standardreport][:metric]
        
      when "Dx"
        @dxmetric = Dxmetric.new(params[:dxmetric])        
        
        @dxmetric.standardreport_id =  Standardreport.find_last_id()[0].max_id.to_i
        
        @dxmetric.save        
        
      when "Vx"             
        @vxmetric = Vxmetric.new(params[:vxmetric])
        
        @vxmetric.standardreport_id =  Standardreport.find_last_id()[0].max_id.to_i;
        
        @vxmetric.save
        
      when "maxDose"        
        @maxdosemetric = Maxdosemetric.new(params[:maxdosemetric])
        
        @maxdosemetric.standardreport_id =  Standardreport.find_last_id()[0].max_id.to_i;
        
        @maxdosemetric.save
        
      when "meanDose"       
        @meandosemetric = Meandosemetric.new(params[:meandosemetric])
        
        @meandosemetric.standardreport_id =  Standardreport.find_last_id()[0].max_id.to_i;
        
        @meandosemetric.save        
        
      when "minDose"        
        @mindosemetric = Mindosemetric.new(params[:mindosemetric])
        
        @mindosemetric.standardreport_id =  Standardreport.find_last_id()[0].max_id.to_i;
        
        @mindosemetric.save        
        
      when "Manual"         
        
      end
      
      redirect_to :action => 'list'
    end
  end
end
