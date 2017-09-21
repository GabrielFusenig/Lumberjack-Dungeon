require 'Gosu'
include Gosu
require 'Sprite.rb'
class Player < Sprite
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y
  
  def initialize(window)
    @image = Image.new("lbj.png", :retro => true)
    super(window, "lbj.png")
    @x = @y = @vel_x = @vel_y = @z = @angle = 0
  end
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
 
  
#=begin
  def move_up(speed)
    if Gosu.button_down? KbW
    @y -=speed
    @angle = 180
    end
  end
  
  def move_down(speed)
    if Gosu.button_down? KbS
    @y +=speed
    @angle = 0
    end
  end
  
  
  def move_left(speed)
    if Gosu.button_down? KbA
    @x -=speed
    @angle = 270
    end
  end
   
  def move_right(speed)
   if Gosu.button_down? KbD
     @x +=speed
     @angle = 90
   end
  end
 
  def move
     @x += @vel_x
     @y += @vel_y
     @vel_x *= 0.75
     @vel_y *= 0.75        
   end

end
#=end
  
=begin 
  def motion(speed)
    if Gosu.button_down? KbD
      @x+=speed
      @angle = 0
    end

    
        
    if Gosu.button_down? KbA
      @x-=speed
      @angle = 180
    end
    
    if Gosu.button_down? KbS
      @y+=speed
      @angle = 90
    end
    
    if Gosu.button_down? KbW
      @y-=speed
      @angle = 270
    end
  end
=end  
  
  
  
  def accelerate(acc)  
    @vel_x += Gosu.offset_x(@angle, acc)  
    @vel_y += Gosu.offset_y(@angle, acc)
  end 
  

  

  def draw
    @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, 1.5, 1.5) 
  end
