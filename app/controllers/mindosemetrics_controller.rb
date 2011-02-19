class MindosemetricsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @mindosemetric_pages, @mindosemetrics = paginate :mindosemetrics, :per_page => 10
  end

  def show
    @mindosemetric = Mindosemetric.find(params[:id])
  end

  def new
    @mindosemetric = Mindosemetric.new
  end

  def create
    @mindosemetric = Mindosemetric.new(params[:mindosemetric])
    if @mindosemetric.save
      flash[:notice] = 'Mindosemetric was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @mindosemetric = Mindosemetric.find(params[:id])
  end

  def update
    @mindosemetric = Mindosemetric.find(params[:id])
    if @mindosemetric.update_attributes(params[:mindosemetric])
      flash[:notice] = 'Mindosemetric was successfully updated.'
      redirect_to :action => 'show', :id => @mindosemetric
    else
      render :action => 'edit'
    end
  end

  def destroy
    Mindosemetric.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
