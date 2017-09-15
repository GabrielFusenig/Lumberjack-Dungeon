require 'Sprite.rb'
class Player < Sprite
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y
  
  def initialize(window)
    @image = Image.new("Sprites/tinyboi.png", :retro => true)
    super(window, "Sprites/tinyboi.png")
    @x = @y = @vel_x = @vel_y = @z = @angle = 0
  end
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
  def turn_left
     @angle -= 4.5 
   end
   
  def turn_right 
     @angle += 4.5
  end
  
  def accelerate(acc)  
    @vel_x += Gosu.offset_x(@angle, acc)  
    @vel_y += Gosu.offset_y(@angle, acc)
  end 
  
  def move
    @x += @vel_x
    @y += @vel_y
    @vel_x *= 0.75
    @vel_y *= 0.75        
  end
  

  def draw
    @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, 4, 4) 
  end
end