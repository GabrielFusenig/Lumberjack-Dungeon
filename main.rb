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
    @font = Font.new(16, :name => "./wind.ttf")
    
    @door1 = Image.new("door1.png", :retro => true)
    @door2 = Image.new("door2.png", :retro => true)
    
    @dungeon = Dungeon.new
    @dungeon.setSize(8, 8)
    @dungeon.generate(42069)
   
  end

  
  
  def update
   #@player.motion(8)
   @player.move()
   
    
   #checking if the player sprite is touching a wall or going through a door
    if @player.x() > 11
      @player.move_left(8)
    end
    
    if @player.x() < 755
      @player.move_right(8)
    end    
        
    if @player.y() > 11
      @player.move_up(8)
    end
    
    if @player.y() < 555
      @player.move_down(8)  
    end

=begin
    if !(@player.x() >= 28 && @player.y() >= 28) 
      @player.warp(@player.x()+10, @player.y()+10, 0)
    elsif !( @player.x() <= 768 && @player.y() <= 568)
      @player.warp(@player.x()-10, @player.y()-10, 0)
    end
=end    
    
  end
  
  def draw
    @background.draw(-1,-1,0,1,1)
    @player.draw
    @cursor.draw(mouse_x, mouse_y, 0, 0.5, 0.5)

    @door1.draw(755, 250, 1, 4, 4)
    @door1.draw(-30, 250, 1, 4, 4)
    @door2.draw(375, -20, 1, 4, 4)
    @door2.draw(375, 565, 1, 4, 4)
   
    if DEBUGGING
      @font.draw("Player coords: #{@player.x}, #{@player.y}", 0, 16, 0)
      @font.draw("Mouse coords: #{mouse_x}, #{mouse_y}",0,0,0)
    end
  end
end

muhny = Game_Window.new
muhny.show

