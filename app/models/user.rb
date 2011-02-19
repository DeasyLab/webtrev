require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  has_many :plans, :dependent => :destroy
  has_many :standardreports, :through => :standardreporttypes
  has_many :assignplans
  
  def self.authenticate(login, pass)
    #    debugger if ENV['RAILS_ENV'] == 'development'
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  
  
  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
  
  def password_check?(pass)
    self.password == self.class.sha1(pass)
  end
  
  protected
  
  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
  
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end
  
  def self.getMD(id)
    if id.nil?
      find_by_sql("SELECT * FROM users WHERE category = 'MD'");
    else
      find_by_sql("SELECT * FROM users WHERE category = 'MD' AND id = #{id}");
    end
  end
  
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create     
end
