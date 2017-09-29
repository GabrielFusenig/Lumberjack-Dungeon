require 'Gosu'
require 'Sprite'
include Gosu

class Health_packs < Sprite
  attr_accessor :health, :x, :y, :z, :angle
  
  def initialize(window, png)
    @image = Image.new(png, :retro => true)
    super(window, png)
    @x = @y = @z = @angle = 0
    @health = (rand(1..2) * 25)
  end
  
 def use_Hpack(player)
   if touching? player
     player.health += @health
   end
   if player.health > player.max_health
     player.health = player.max_health
   end
 end
     
 
 def draw
   if visible?
   @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 1.5, 1.5)
   end
 end
  #the class' end, don't go past
end