class Standardreporttype < ActiveRecord::Base
  belongs_to :user
  
  def self.allReport(id)
    debugger if ENV['RAILS_ENV'] == 'development'
    find_by_sql( "SELECT reportName FROM standardreporttype WHERE user_id = #{id}");
  end
  
end
