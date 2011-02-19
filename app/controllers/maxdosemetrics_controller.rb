class MaxdosemetricsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @maxdosemetric_pages, @maxdosemetrics = paginate :maxdosemetrics, :per_page => 10
  end

  def show
    @maxdosemetric = Maxdosemetric.find(params[:id])
  end

  def new
    @maxdosemetric = Maxdosemetric.new
  end

  def create
    @maxdosemetric = Maxdosemetric.new(params[:maxdosemetric])
    if @maxdosemetric.save
      flash[:notice] = 'Maxdosemetric was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @maxdosemetric = Maxdosemetric.find(params[:id])
  end

  def update
    @maxdosemetric = Maxdosemetric.find(params[:id])
    if @maxdosemetric.update_attributes(params[:maxdosemetric])
      flash[:notice] = 'Maxdosemetric was successfully updated.'
      redirect_to :action => 'show', :id => @maxdosemetric
    else
      render :action => 'edit'
    end
  end

  def destroy
    Maxdosemetric.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
