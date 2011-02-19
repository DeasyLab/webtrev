class StandardreporttypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list
    @standardreporttype_pages, @standardreporttypes = paginate :standardreporttypes, :per_page => 10
  end
  
  def show
    @standardreporttype = Standardreporttype.find(params[:id])
  end
  
  def form
    case request.method
    when :post      
      render  :partial => "form"
    end
  end
  
  def new
    @standardreporttype = Standardreporttype.new
  end
  
  def create    
    @standardreporttype = Standardreporttype.new(params[:standardreporttype])
    @standardreporttype.user_id = session['user'].id
    if @standardreporttype.save
      redirect_to :action => ''
    else
      render :action => 'new'
    end
  end
  
  def edit
    @standardreporttype = Standardreporttype.find(params[:id])
  end
  
  def update
    @standardreporttype = Standardreporttype.find(params[:id])
    if @standardreporttype.update_attributes(params[:standardreporttype])
      flash[:notice] = 'Standardreporttype was successfully updated.'
      redirect_to :action => 'show', :id => @standardreporttype
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Standardreporttype.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
