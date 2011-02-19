class DxmetricsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @dxmetric_pages, @dxmetrics = paginate :dxmetrics, :per_page => 10
  end

  def show
    @dxmetric = Dxmetric.find(params[:id])
  end

  def new
    @dxmetric = Dxmetric.new
  end

  def create
    @dxmetric = Dxmetric.new(params[:dxmetric])
    if @dxmetric.save
      flash[:notice] = 'Dxmetric was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @dxmetric = Dxmetric.find(params[:id])
  end

  def update
    @dxmetric = Dxmetric.find(params[:id])
    if @dxmetric.update_attributes(params[:dxmetric])
      flash[:notice] = 'Dxmetric was successfully updated.'
      redirect_to :action => 'show', :id => @dxmetric
    else
      render :action => 'edit'
    end
  end

  def destroy
    Dxmetric.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
