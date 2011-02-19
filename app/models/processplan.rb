class Processplan < ActiveRecord::Base
  has_many :alldose
  has_many :inplanparam
  has_many :standardreporttype
  has_many    :dxmetric
  has_many    :mindosemetric
  has_many    :meandosemetric
  has_many    :maxdosemetric
  has_many    :vxmetric
  
  def self.setparamflg(id)
    @processplan = find_by_sql( "SELECT structurename FROM allstructs WHERE processplan_id = #{id}");    
  end
  
  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/pinnacleReport"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }    
  end
end
