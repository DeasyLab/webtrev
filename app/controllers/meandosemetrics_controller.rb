class MeandosemetricsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @meandosemetric_pages, @meandosemetrics = paginate :meandosemetrics, :per_page => 10
  end

  def show
    @meandosemetric = Meandosemetric.find(params[:id])
  end

  def new
    @meandosemetric = Meandosemetric.new
  end

  def create
    @meandosemetric = Meandosemetric.new(params[:meandosemetric])
    if @meandosemetric.save
      flash[:notice] = 'Meandosemetric was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @meandosemetric = Meandosemetric.find(params[:id])
  end

  def update
    @meandosemetric = Meandosemetric.find(params[:id])
    if @meandosemetric.update_attributes(params[:meandosemetric])
      flash[:notice] = 'Meandosemetric was successfully updated.'
      redirect_to :action => 'show', :id => @meandosemetric
    else
      render :action => 'edit'
    end
  end

  def destroy
    Meandosemetric.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
