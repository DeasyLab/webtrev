class CommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end
  
  def form
    /# debugger if ENV['RAILS_ENV'] == 'development'/
    if session['view'].eql?('dvh')
                
      if session['dvh_id'].eql?(0)
        return
      else
        i = 0;
        for dvh_id in session['dvh_id']
          i = i+1;
          if dvh_id.eql?(params['dvh']['dropdown'])
            #debugger if ENV['RAILS_ENV'] == 'development'
            @dvh_indx = i;
          end
        end
      end
    end
    #debugger if ENV['RAILS_ENV'] == 'development'
    case request.method
      when :post      
      render  :partial => "form", :layout => false
    end
  end
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list
    /# @comment_pages, @comments = paginate :comments, :per_page => 10/
    session[:review_id] = params[:review_id];
    @review_id = params[:review_id]
    render :partial => 'list'
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.created_at = DateTime::now.strftime
    @comment.created_by = session['user'].firstname
    @comment.review_id = session[:review_id];
    
    #    debugger if ENV['RAILS_ENV'] == 'development'
    
    if @comment.save
      @review_id = session[:review_id]
      render :partial => 'list'      
    else
      render :action => 'new'
    end
  end
  
  def newCommentDropDown
    render :partial => 'newCommentDropDown', :layout => false
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to :action => 'show', :id => @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
