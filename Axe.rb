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
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 1, 1)
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
  	case @angle
  	when 0
	    self_upper_left_x = @x - (self.width / 2)
	    self_upper_left_y = @y - (self.height / 2)
	    self_lower_right_x = @x + (self.width / 2)
	    self_lower_right_y = @y + (self.height / 2)
  	when 180
	    self_upper_left_x = @x - (self.width / 2)
	    self_upper_left_y = @y - (self.height / 2)
	    self_lower_right_x = @x + (self.width / 2)
	    self_lower_right_y = @y + (self.height / 2)
  	when 90
	    self_upper_left_x = @x - (self.height / 2)
	    self_upper_left_y = @y - (self.width / 2)
	    self_lower_right_x = @x + (self.height / 2)
	    self_lower_right_y = @y + (self.width / 2)
  	when 270
	    self_upper_left_x = @x - (self.height / 2)
	    self_upper_left_y = @y - (self.width / 2)
	    self_lower_right_x = @x + (self.height / 2)
	    self_lower_right_y = @y + (self.width / 2)
  	end

    other_upper_left_x = enemy.x - (enemy.width / 2)
    other_upper_left_y = enemy.y - (enemy.height / 2)
    other_lower_right_x = enemy.x + (enemy.width / 2)
    other_lower_right_y = enemy.y + (enemy.height / 2)
    
		if (enemy.visible? and self.visible?)
			if (other_upper_left_x.between?(self_upper_left_x, self_lower_right_x) or other_lower_right_x.between?(self_upper_left_x, self_lower_right_x))
				if (other_upper_left_y.between?(self_upper_left_y, self_lower_right_y) or other_lower_right_y.between?(self_upper_left_y, self_lower_right_y))
					enemy.take_dmg(@dmg, wav)
				end
			end
			if (self_upper_left_x.between?(other_upper_left_x, other_lower_right_x) or self_lower_right_x.between?(other_upper_left_x, other_lower_right_x))
				if (self_upper_left_y.between?(other_upper_left_y, other_lower_right_y) or self_lower_right_y.between?(other_upper_left_y, other_lower_right_y))
					enemy.take_dmg(@dmg, wav)
				end
			end
		end
  end
    
end