class Review < ActiveRecord::Base
  belongs_to    :plan 
  has_many      :dvhstat
  acts_as_list	:scope => :plan
  
  def self.find_photo(id ,view)
    find_by_sql( "SELECT * FROM reviews WHERE reviews.plan_id=#{id} AND reviews.view_type = '#{view}' ");
  end
  
  def self.find_structonslice(id ,view, structNum)
    find_by_sql( "SELECT * FROM reviews WHERE reviews.plan_id=#{id} AND reviews.view_type = '#{view}' AND reviews.str#{structNum} = 1");
  end
  
  def self.find_structonslice_all(id,review_id)
    @structLegend = Array.new       
    
    for i in 1..62
      structNum = i.to_s;
      strClr = "str" + structNum + "clr";      
      
      @out = find_by_sql("SELECT str#{structNum}, #{strClr} FROM reviews WHERE reviews.plan_id = #{id} AND reviews.id = #{review_id}");    
      
      isStruct = eval "@out[0].str#{structNum}"
      
      if   isStruct == 1
        strColor = eval "@out[0].#{strClr}"
        structName = Dvhstat.structName_by_structNum(id,structNum)
        @structLegend << [structNum, structName[0].structName , strColor]        
      end
      
    end
    @structLegend
  end
  
  def full(  ) file end
  
  def thumb
    debugger if ENV['RAILS_ENV'] == 'development'
    with_image do |image|
      debugger if ENV['RAILS_ENV'] == 'development'
      image = image.change_geometry('100x100') do |cols, rows, img|
        img.resize!(cols, rows)
      end
      image = image.crop(Magick::CenterGravity, 100, 100)
      image.profile!('*', nil)      
      return image.to_blob { self.format='png'; self.quality = 60 }
    end
  end
  
  private
  
  def with_image file=nil
    data = Base64.b64encode(file || self.image)
    img = Magick::Image::read_inline(data).first
    yield img
    img = nil
    GC.start
  end
  
end