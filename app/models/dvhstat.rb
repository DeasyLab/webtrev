class Dvhstat < ActiveRecord::Base
  belongs_to :review
  
  def self.allstructbyplan(id)
    find_by_sql( "SELECT structName, structNum FROM dvhstats WHERE plan_id = #{id}");
  end
  
  def self.structName_by_review_id(id)
    find_by_sql( "SELECT structName FROM dvhstats WHERE review_id = #{id}");
  end
  
  def self.all_istarget(id)
    find_by_sql("SELECT * FROM dvhstats WHERE plan_id = #{id} AND istarget = 1");
  end
  
  def self.structName_by_structNum(id,structNum)
    find_by_sql( "SELECT structName FROM dvhstats WHERE plan_id = #{id} AND structNum = #{structNum}");    
  end
  
end
