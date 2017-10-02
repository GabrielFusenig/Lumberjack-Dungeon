require 'Gosu'
require 'Sprite.rb'
include Gosu


class Player < Sprite
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y, :health, :max_health, :roomx, :roomy
  
  def initialize(window)
    @image = Image.new("lbj.png", :retro => true)
    super(window, "lbj.png")
    @x = @y = @vel_x = @vel_y = @z = @angle = 0
    @health = @max_health = 300
    @oof = Sample.new("./hitsound.wav")
    @roomx = @roomy = 0
  end
 
  def warp(x,y,z)
      @x, @y, @z = x, y, z
    end
 
  
#=begin
  def move_up(speed)
    if Gosu.button_down? KbW
      @y -=speed
      -@angle = -90
    end
  end
  
  def move_down(speed)
    if Gosu.button_down? KbS
      @y +=speed
      @angle = 90
    end
  end
  
  
  def move_left(speed)
    if Gosu.button_down? KbA
      @x -=speed
      @angle = 180
    end
  end
   
  def move_right(speed)
   if Gosu.button_down? KbD
     @x +=speed
     @angle = 0
   end
  end
 
  def move
     @x += @vel_x
     @y += @vel_y
     @vel_x *= 0.75
     @vel_y *= 0.75        
   end


#=end
  

  def take_damage(damage)
      @health -= damage
      @oof.play
  end
 
 
  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 1.5, 1.5) 
    
    case @health
      when (@max_health/4)..(@max_health/2)
        draw_rect(@x - 16, @y - 25, 32.0 * (1.0 * @health/@max_health), 2, Color::YELLOW)
      when 0..(@max_health/4)
        draw_rect(@x - 16, @y - 25, 32.0 * (1.0 * @health/@max_health), 2, Color::RED)
      else
        draw_rect(@x - 16, @y - 25, 32.0 * (1.0 * @health/@max_health), 2, Color::GREEN)
      end
   
  end
end