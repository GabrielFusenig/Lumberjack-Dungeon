require 'gosu'
require 'Sprite.rb'
require 'Player'
require 'dungen'
include Gosu

DEBUGGING = true


class Game_Window < Window
  def initialize
    super 800, 600
    self.caption = "Placeholder Game Name"
    @background = Image.new("bg room.png", :retro => true)
    @player = Player.new(self)
    @player.warp(400,300,1)
    @cursor = Image.new("cursor.png", :retro => true)
    @font = Font.new(16, :name => "./PixelFJVerdana12pt.ttf")
  end

  
  
  def update
    @player.motion(8)
    @player.move()
    
  end
  
  def draw
    @background.draw(-1,-1,0,1,1)
    @player.draw
    @cursor.draw(mouse_x, mouse_y, 0, 0.5, 0.5)
    if DEBUGGING
      @font.draw("Mouse coords: #{mouse_x}, #{mouse_y}",0,0,0)
    end
  end
end

muhny = Game_Window.new
muhny.show

