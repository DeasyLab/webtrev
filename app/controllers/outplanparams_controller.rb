class OutplanparamsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    debugger if ENV['RAILS_ENV'] == 'development'
       
        items_per_page = 10
    
    sort = case params['sort']
    when "Structure"  then "structure"
    when "Result"      then "goals"
    when "Category"   then "category"        
      
    when "Structure_reverse"  then "structure DESC"
    when "Result_reverse"      then "goals DESC"
    when "Category_reverse"   then "category DESC"         
    end
        
    conditions = ["plan_id = ?", "#{session['plan']['id']}"]
        
    @total = Outplanparam.count(:conditions => conditions)      
    
    @outplanparam_pages, @outplanparams = paginate :outplanparams, :order => sort, :conditions => conditions, :per_page => items_per_page
     
#    @outplanparam_pages, @outplanparams = paginate :outplanparams, :per_page => 10
    
    render :partial => "outplanparams_list", :layout => false
  end

  def show
    @outplanparam = Outplanparam.find(params[:id])
  end

  def new
    @outplanparam = Outplanparam.new
  end

  def create
    @outplanparam = Outplanparam.new(params[:outplanparam])
    if @outplanparam.save
      flash[:notice] = 'Outplanparam was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @outplanparam = Outplanparam.find(params[:id])
  end

  def update
    @outplanparam = Outplanparam.find(params[:id])
    if @outplanparam.update_attributes(params[:outplanparam])
      flash[:notice] = 'Outplanparam was successfully updated.'
      redirect_to :action => 'show', :id => @outplanparam
    else
      render :action => 'edit'
    end
  end

  def destroy
    Outplanparam.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
