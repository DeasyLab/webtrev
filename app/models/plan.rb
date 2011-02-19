class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, :order => "position", :dependent => :destroy
  has_many :assignplans
  
     
end
