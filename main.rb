require 'gosu'
require 'Sprite'
require 'Player'
require 'dungen'
require 'Enemy'
include Gosu

DEBUGGING = true
is_dead = false

class Game_Window < Window
  def initialize
    super 800, 600
    self.caption = "Placeholder Game Name"
    @background = Image.new("bg room.png", :retro => true)
    
    @fucked = Sample.new("./deathsound.wav")
    
    @player = Player.new(self)
    @player.warp(400,300,1)
    
    @cursor = Image.new("cursor.png", :retro => true)
    
    @font = Font.new(16, :name => "./wind.ttf")
    
    @zombie = Enemy.new(self , "./zombie.png")
    @zombie.warp( 450,350 , 1)
    
    @door1 = Image.new("door1.png", :retro => true)
    @door2 = Image.new("door2.png", :retro => true)
    
    @dungeon = Dungeon.new
    @dungeon.setSize(8, 8)
    @dungeon.generate(42069)
   
  end

  @@speeed = 4
  
  def update
    
    if Gosu.button_down? KB_ESCAPE
      self.close
    end
       
   #@player.move()
   
    if @player.touching?(@zombie)
      @player.take_damage(1)
    end
    
   #checking if the player sprite is touching a wall or going through a door
   if @player.health > 0
    if @player.x() > 30
      @player.move_left(@@speeed)
    end
    
    if @player.x() < 755
      @player.move_right(@@speeed)
    end    
        
    if @player.y() > 30
      @player.move_up(@@speeed)
      
    end
    
    if @player.y() < 555
      @player.move_down(@@speeed)  
    end
   else
     @player.warp(0,0,1)
     @fucked.play
   end
  end

  
  #####################################################
  
    
  def draw
    @background.draw(-1,-1,0,1,1)
   
    if @player.health > 0
      @player.draw
    else
      
      @player.angle = 180
      @player.z = 2
    end
    
    @cursor.draw(mouse_x, mouse_y, 0, 0.5, 0.5)

    @zombie.draw
    
    @door1.draw(755, 250, 0, 4, 4)
    @door1.draw(-30, 250, 0, 4, 4)
    @door2.draw(375, -20, 0, 4, 4)
    @door2.draw(375, 565, 0, 4, 4)
    


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

