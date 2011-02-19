class Inplanparam < ActiveRecord::Base
belongs_to  :processplan
has_many    :allstruct
has_many    :dxmetric
has_many    :mindosemetric
has_many    :meandosemetric
has_many    :maxdosemetric

  def self.find_last_id()
      find_by_sql( "SELECT MAX(id)as max_id FROM inplanparams");      
  end
end
