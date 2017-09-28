require 'Gosu'
require 'Sprite'
require 'Player'
require 'Enemy'
include Gosu

class Axe < Sprite
  attr_accessor :x, :y, :z, :angle, :dmg
  
  def initialize(window, png, dmg)
    @image = Image.new(png, :retro => true)
    super(window, png)
    @x = @y = @z = @angle = 0
    @dmg = dmg
  end
  
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
  
    
  def draw
    if visible?
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 1.5, 1.5)
    end 
  end
    
    def attack(player)
      @angle = player.angle + 90
      if @angle == 90
        @x = player.x + 40
        @y = player.y
      elsif @angle == 180
        @x = player.x
        @y = player.y + 40
      elsif @angle == 270
        @x = player.x - 40
        @y = player.y
      elsif @angle == 0
        @x = player.x
        @y = player.y - 40
      end
    end
    
    def axe(enemy)
      if touching? enemy
        enemy.take_dmg(@dmg)
      end
    end
    
end