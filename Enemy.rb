require 'Gosu'
include Gosu
require 'Sprite.rb'
require 'Player'


class Enemy < Sprite
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y
  
  def initialize(window, sprite)
    @image = Image.new(sprite, :retro => true)
    super(window, sprite)
    @x = @y = @vel_x = @vel_y = @z = @angle = 0
  end
  
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
  
  
  def attack(player)
    angle = Math.atan((1.0 * player.y - @y)/(player.x - @x))
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
    @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, 1.5, 1.5) 
  end
end

