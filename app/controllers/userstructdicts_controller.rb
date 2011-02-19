class UserstructdictsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

#  def list
#    @userstructdict_pages, @userstructdicts = paginate :userstructdicts, :per_page => 10
#  end

  def list  
    items_per_page = 20
    
    sort = case params['sort']
    when "Structure"  then "structurename"      
    when "Structure_reverse"  then "structurename DESC"
    end
    
    if !params[:structquerySTR].nil?
      conditions = ["structurename LIKE ? AND user_id = ?", "%#{params[:structquerySTR]}%", "#{session['user']['id']}"]      
    else
      conditions = ["user_id = ?", "#{session['user']['id']}"]
    end
    
#    debugger if ENV['RAILS_ENV'] == 'development'
    
    @total = Userstructdict.count(:conditions => conditions)      
    
    @userstructdict_pages, @userstructdicts = paginate :userstructdicts, :order => sort, :conditions => conditions, :per_page => items_per_page
    
#    if request.xml_http_request?
#      render :partial => "inplanparams_list", :layout => false
#    end      
  end
  
  def show
    @userstructdict = Userstructdict.find(params[:id])
  end

  def new
    @userstructdict = Userstructdict.new
  end

  def create
#    debugger if ENV['RAILS_ENV'] == 'development'
    
    @userstructdict = Userstructdict.new(params[:userstructdict])

    if @userstructdict.save
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
    
  end

  def edit
    @userstructdict = Userstructdict.find(params[:id])
    render :partial => 'edit'
  end

  def update
    @userstructdict = Userstructdict.find(params[:id])
    if @userstructdict.update_attributes(params[:userstructdict])
      flash[:notice] = 'Userstructdict was successfully updated.'
      redirect_to :action => 'list'
    end
  end

  def destroy
    Userstructdict.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
