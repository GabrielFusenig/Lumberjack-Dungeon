require 'Gosu'
include Gosu
require 'Sprite.rb'


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
  
end
