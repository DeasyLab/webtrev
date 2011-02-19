class AccountController < ApplicationController
  model   :user
  layout  'scaffold'
  
  def login
    case @request.method
      when :post
      if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])
        
        flash['notice']  = "Login successful"
        
        @session['planType'] = ''
        
        if isMD
          redirect_to :controller=>"plans", :action => "unapproved"
        else          
          redirect_to :controller=>"processplans", :action => "process_list"
        end
        
        
      else
        @login    = @params['user_login']
        @message  = "Login unsuccessful"
      end
    end
  end
  
  def signup
    case @request.method
      when :post
      @user = User.new(@params['user'])
      
      if @user.save      
        @session['user'] = User.authenticate(@user.login, @params['user']['password'])
        flash['notice']  = "Signup successful"
        redirect_back_or_default :action => "welcome"          
      end
      when :get
      @user = User.new
    end      
  end  
  
  def delete
    if @params['id'] and @session['user']
      @user = User.find(@params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "welcome"
  end  
  
  def logout
    @session['user'] = nil
  end
  
  def changePass  
    case @request.method
      when :post      
      render  :partial => "changePass"
    end     
  end
  
  def change_password
    @user = @session['user']
    @session['message'] = nil
    case @request.method
      when :post
      unless @user.password_check?(@params['old_password'])
        @session['message'] = 'You have introduced a wrong password!'
      else
        unless @params['new_password'] == @params['new_password_confirmation']
          @session['message'] = 'Your password and password confirmation dont match!'
        else
          @session['message'] = 'Your password was changed successfully!' if @user.change_password(@params['new_password'])
        end
      end
      redirect_to :controller => "settings", :action => "list"
      
      #      redirect_back_or_default :controller => "login", :action => "change_password" 
    end
  end
  
  def forgot_password
    case @request.method
      when :post
      render  :partial => "forgotPass"
    end        
  end   
  
  def sendMailForgotPass  # Method to send Mails for password
    begin
      @user = find_by_login(params[:address_to_send])
      Notifier.deliver_forgot_password(@user)        
      redirect_to :action => "sendMailMessage"
    rescue StandardError => e
      puts e
      alert(e);
    end        
  end
  
  def sendMailMessage      
  end
  private 
  
  def isMD
    return @session['user'].category.eql?("MD")
  end 
end
