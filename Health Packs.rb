require 'Gosu'
require 'Sprite'
include Gosu

class Health_packs < Sprite
  attr_accessor :health, :x, :y, :z, :angle
  
  def initialize(window)
    @half = Image.new("./half_heart32.png", :retro => true)
    @full = Image.new("./full_heart32.png", :retro => true)
    super(window, "./full_heart32.png")
    @x = @y = @z = @angle = 0
    @health = (rand(1..2) * 25)
    self.hide
  end
  
  def use(player)
    if touching? player
      player.health += @health
      self.hide
      @health = rand(1..2) * 25 #rerolll
    end
    
    if player.health > player.max_health
      player.health = player.max_health
    end
  end
 
 
 	def draw
 		if visible?
 		  if @health == 25
 		    @half.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, 1, 1)
 		  elsif
 		    @full.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, 1, 1)
 		  end
 		end
 	end
  #the class' end, don't go past
end

