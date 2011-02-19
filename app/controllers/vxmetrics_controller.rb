class VxmetricsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @vxmetric_pages, @vxmetrics = paginate :vxmetrics, :per_page => 10
  end

  def show
    @vxmetric = Vxmetric.find(params[:id])
  end

  def new
    @vxmetric = Vxmetric.new
  end

  def create
    @vxmetric = Vxmetric.new(params[:vxmetric])
    if @vxmetric.save
      flash[:notice] = 'Vxmetric was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @vxmetric = Vxmetric.find(params[:id])
  end

  def update
    @vxmetric = Vxmetric.find(params[:id])
    if @vxmetric.update_attributes(params[:vxmetric])
      flash[:notice] = 'Vxmetric was successfully updated.'
      redirect_to :action => 'show', :id => @vxmetric
    else
      render :action => 'edit'
    end
  end

  def destroy
    Vxmetric.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
