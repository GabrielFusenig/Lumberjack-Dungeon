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

  
  #the chainsaw attack method, moves the chainsaw to different positions around the player depending on the button pressed
  def attack(player)
    if Gosu.button_down? KbI
      
      self.show
      @angle = 0
      @x = player.x
      @y = player.y - 40
      
      ####################################
    elsif Gosu.button_down? KbJ
      self.show
      @angle = 270
      @x = player.x - 40
      @y = player.y
      
      ###################################
    elsif Gosu.button_down? KbK
      self.show
      @angle = 180
      @x = player.x
      @y = player.y + 40
      
      ###################################
    elsif Gosu.button_down? KbL
      self.show
      @angle = 90
      @x = player.x + 40
      @y = player.y
      
      ###################################
    else
      self.hide
    end
  end
 
  
    def axe(enemy, wav)
      if touching? enemy
        enemy.take_dmg(@dmg, wav)
      end
    end
    
end