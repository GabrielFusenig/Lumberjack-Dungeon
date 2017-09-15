require 'gosu'
require 'Sprite.rb'
require 'Player'
include Gosu

class Game_Window < Window
  def initialize
    super 800, 600
    self.caption = "Placeholder Game Name"
    @background = Image.new("Sprites/bg.png", :retro => true)
    @player = Player.new(self)
    @player.warp(400,300,1)
  end

  def update
    if Gosu.button_down? KbA
      @player.turn_left()
    end
    if Gosu.button_down? KbD
      @player.turn_right() 
    end
    if Gosu.button_down? KbW
      @player.accelerate(1)
    end
    if Gosu.button_down? KbS
      @player.accelerate(-1)
    end
    @player.move()
    
  end
  
  def draw
    @background.draw(-1,-1,0,4,4)
    @player.draw
  end
end

@muhny = Game_Window.new
@muhny.show