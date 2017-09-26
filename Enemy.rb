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
  
  
  def draw
    @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, 1.5, 1.5) 
  end
  
  def attack(player)
    angle = Math.atan((player.x - @x)/(player.y - @y))
    @angle = angle
    @vel_x = 3 * Math.cos(angle)
    @vel_y = 3 * Math.sin(angle)
    @x -= @vel_x
    @y -= @vel_y
  end
end

