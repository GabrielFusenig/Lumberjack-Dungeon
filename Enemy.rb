require 'Gosu'
require 'Sprite.rb'
require 'Player'
include Gosu


class Enemy < Sprite
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y, :health, :max_health
  
  def initialize(window, sprite)
    @image = Image.new(sprite, :retro => true)
    super(window, sprite)
    @vel_x = @vel_y = @z = @angle = 0
    @health = @max_health =100
    @x = rand(50..750)
    @y = rand(50..550)
  end
  
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
  
  def take_dmg(dmg)
    @health -= dmg
  end
  
  
  def attack(player)
    angle = Math.atan((1.0 * player.y - @y) / (player.x - @x))
    
    if player.x > @x
      angle -= Math::PI
    end
    
    @angle = (angle * 180 / Math::PI) + 90
    @vel_x = 2 * Math.cos(angle)
    @vel_y = 2 * Math.sin(angle)
    @x -= @vel_x
    @y -= @vel_y
  end
  
  
   def draw
     if visible?
        @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, 1.5, 1.5) 
    
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
end
