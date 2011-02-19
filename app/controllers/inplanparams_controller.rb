class InplanparamsController < ApplicationController
  model     :inplanparam
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list  
    items_per_page = 10
    
    sort = case params['sort']
      when "Structure"  then "structure"
      when "Goals"      then "goals"
      when "Category"   then "category"        
      when "Metric"     then "metric"
      
      when "Structure_reverse"  then "structure DESC"
      when "Goals_reverse"      then "goals DESC"
      when "Category_reverse"   then "category DESC"         
      when "Metric_reverse"  then "metric DESC"
    end
    
    if !params[:querySTR].nil?
      conditions = ["structure LIKE ? AND processplan_id = ?", "%#{params[:querySTR]}%", "#{session['processplan_id']}"]      
    else
      conditions = ["processplan_id = ?", "#{session['processplan_id']}"]
    end
    
    @total = Inplanparam.count(:conditions => conditions)      
    
    @inplanparam_pages, @inplanparams = paginate :inplanparams, :order => sort, :conditions => conditions, :per_page => items_per_page
    
    if request.xml_http_request?
      render :partial => "inplanparams_list", :layout => false
    end      
  end     
  
  def show
    @inplanparam = Inplanparam.find(params[:id])
  end
  
#  def report
#    items_per_page = 10
#    
#    sort = case params['sort']
#      when "Structure"  then "structure"
#      when "Result"      then "goals"
#      when "Category"   then "category"        
#      
#      when "Structure_reverse"  then "structure DESC"
#      when "Result_reverse"      then "goals DESC"
#      when "Category_reverse"   then "category DESC"         
#    end
#    
#    
#    conditions = ["plan_id = ?", "#{session['plan']['id']}"]
#    
#    @total =  Inplanparam.count(:conditions => conditions)      
#    
#    @inplanparam_pages, @inplanparams = paginate :inplanparams, :order => sort, :conditions => conditions, :per_page => items_per_page
#    
#    /#    @inplanparam_pages, @inplanparams = paginate :inplanparams, :per_page => 10/
#    
#    render :partial => "report", :layout => false
#  end
  
  def report
    @pinnacle_report = session['plan']['report_upload'];
    render :render => "report", :layout => false
  end
  
  def selectMetric
    /#    debugger if ENV['RAILS_ENV'] == 'development'/  
    @inplanparam = Inplanparam.new
    render :partial => "selectMetric", :layout => false
  end
  
  /
  #  def create
  #    @inplanparam = Inplanparam.new(params[:inplanparam])
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      redirect_to :action => 'list',  :layout =>'false'
  #    end
  #  end
  /
  
  def edit
    @inplanparam = Inplanparam.find(params[:id])
  end
  
  def update
    @inplanparam = Inplanparam.find(params[:id])
    if @inplanparam.update_attributes(params[:inplanparam])
      redirect_to :action => 'show', :id => @inplanparam
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Inplanparam.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def dispmetric
    
    session['inplanparam_structure '] = params[:inplanparam_structure]
    
    session['inplanparam_category'] = params[:inplanparam_category]
    
    session['inplanparam_metric']= params[:inplanparam_metric]
    
    case params[:inplanparam_metric]
      
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
      @inplanparam = Inplanparam.new
      render :partial => "new", :layout => false  
    end        
    
  end
  
  def updatemetrics
    
    /#    debugger if ENV['RAILS_ENV'] == 'development'/ 
    
    @inplanparam = Inplanparam.new(params[:inplanparam]);
    
    @inplanparam.processplan_id = session['processplan_id']
    
    /#    debugger if ENV['RAILS_ENV'] == 'development'/ 
    
    if @inplanparam.save
      Inplanparam.belongs_to(:processplan)
      
      @processplan = Processplan.find(session['processplan_id'])      
      
      @processplan.update_attribute("planparamflg", "1")
      
      case params[:inplanparam][:metric]
        
        when "Dx"
        @dxmetric = Dxmetric.new(params[:dxmetric])        
        
        @dxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i
        
        @dxmetric.save        
        
        when "Vx"             
        @vxmetric = Vxmetric.new(params[:vxmetric])
        
        @vxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
        
        @vxmetric.save
        
        when "maxDose"        
        @maxdosemetric = Maxdosemetric.new(params[:maxdosemetric])
        
        @maxdosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
        
        @maxdosemetric.save
        
        when "meanDose"       
        @meandosemetric = Meandosemetric.new(params[:meandosemetric])
        
        @meandosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
        
        @meandosemetric.save        
        
        when "minDose"        
        @mindosemetric = Mindosemetric.new(params[:mindosemetric])
        
        @mindosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
        
        @mindosemetric.save        
        
        when "Manual"         
        
      end
      
      redirect_to :action => 'list'
    end
  end
  /
  #  def updatedx                 
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      @dxmetric = Dxmetric.new(params[:dxmetric])        
  #      
  #      @dxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i
  #      
  #      if @dxmetric.save        
  #        redirect_to :action => 'list'
  #      end  
  #    end    
  #  end
  #  
  #  def updatevx    
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      @vxmetric = Vxmetric.new(params[:vxmetric])
  #      
  #      @vxmetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
  #      
  #      if @vxmetric.save        
  #        redirect_to :action => 'list'
  #      end  
  #      
  #    end
  #  end
  #  
  #  def updatemindose
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      @mindosemetric = Mindosemetric.new(params[:mindosemetric])
  #      
  #      @mindosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
  #      
  #      if @mindosemetric.save        
  #        redirect_to :action => 'list'
  #      end  
  #      
  #    end
  #  end
  #  
  #  def updatemaxdose
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      @maxdosemetric = Maxdosemetric.new(params[:maxdosemetric])
  #      
  #      @maxdosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
  #      
  #      if @maxdosemetric.save        
  #        redirect_to :action => 'list'
  #      end  
  #    end
  #  end
  #  
  #  def updatemeandose
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #      @meandosemetric = Meandosemetric.new(params[:meandosemetric])
  #      
  #      @meandosemetric.inplanparam_id =  Inplanparam.find_last_id()[0].max_id.to_i;
  #      
  #      if @meandosemetric.save        
  #        redirect_to :action => 'list'
  #      end  
  #    end
  #  end
  #  
  #  def updatemanualmetric
  #    @inplanparam = Inplanparam.new();
  #    
  #    @inplanparam.processplan_id = session['processplan_id']
  #    
  #    @inplanparam.structure = session['inplanparam_structure '] 
  #    
  #    @inplanparam.category = session['inplanparam_category'] 
  #    
  #    @inplanparam.metric = session['inplanparam_metric']
  #    
  #    if @inplanparam.save
  #      Inplanparam.belongs_to(:processplan)
  #      
  #      @processplan = Processplan.find(session['processplan_id'])      
  #      
  #      @processplan.update_attribute("planparamflg", "1")
  #      
  #    end
  #  end
  /  
end