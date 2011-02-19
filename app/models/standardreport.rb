class Standardreport < ActiveRecord::Base
  belongs_to :standardreporttype
    
  has_many    :allstruct
  has_many    :dxmetric
  has_many    :mindosemetric
  has_many    :meandosemetric
  has_many    :maxdosemetric
  has_many    :vxmetric
  has_many    :userstructdict

  def self.find_last_id()
      find_by_sql( "SELECT MAX(id)as max_id FROM standardreports");      
  end
end
