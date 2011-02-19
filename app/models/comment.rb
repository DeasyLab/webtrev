class Comment < ActiveRecord::Base
  def self.findByReviewID(id)
    find_by_sql( "SELECT * FROM comments WHERE comments.review_id=#{id}");
  end
end
