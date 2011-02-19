class Allstruct < ActiveRecord::Base
  belongs_to :inplanparam
    
  def self.allstructName(id)
    find_by_sql( "SELECT structurename FROM allstructs WHERE processplan_id = #{id}");
  end  
end
