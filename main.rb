require 'gosu'
require 'Sprite'
require 'Player'
require 'dungen'
require 'Enemy'
require 'Axe'
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
    
    @font = Font.new(16, :name => "./munro.ttf")
    @game_over = Font.new(64, :name => "./munro.ttf")
        
    @zombies = Array.new(rand(1..5)) { Enemy.new(self , "./zombie.png") }
    #@zombie = Enemy.new(self , "./zombie.png")
    #@zombie.warp( 450,350 , 1)
    @zombie_damage = 4
      
    @chainsaw = Axe.new(self, "./chainsaw.png", 4)
   
    
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
  
=begin
    if Gosu.button_down? KB_SPACE
      @chainsaw.show
      @chainsaw.attack(@player)
    else
      @chainsaw.hide
    end
=end 
      
    @chainsaw.attack(@player)
    if Gosu.button_down? KbI
      @player.angle = 270
    elsif Gosu.button_down? KbK
      @player.angle = 90
    elsif Gosu.button_down? KbJ
      @player.angle = 180
    elsif Gosu.button_down? KbL
      @player.angle = 0
    end
    
     
  unless @player.health <= 0
    @zombies.each {|zombie|
      @chainsaw.axe(zombie)
      zombie.attack(@player)
      if zombie.touching?(@player)
        @player.take_damage(@zombie_damage)
      end
      if zombie.health <= 0
        zombie.hide
      end
    }
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
     is_dead = true
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

    @zombies.each {|zombie|
      zombie.draw
    }
    
    @door1.draw(755, 250, 0, 4, 4)
    @door1.draw(-30, 250, 0, 4, 4)
    @door2.draw(375, -20, 0, 4, 4)
    @door2.draw(375, 565, 0, 4, 4)

   
    @chainsaw.draw
    
   
    
    if DEBUGGING
      @font.draw("Mouse coords: #{mouse_x}, #{mouse_y}", 0, 0, 0)
      @font.draw("Player coords: #{@player.x}, #{@player.y}", 0, 16, 0)
      #@font.draw("Player angle: #{@player.angle}", 0, 32, 0)
      #@font.draw("Chain saw angle: #{@chainsaw.angle}, #{@player.angle + 90}", 0, 48, 0)
      #@font.draw("Chainsaw pos: #{@chainsaw.x}, #{@chainsaw.y}", 0, 64, 0)
    end
    
    if @player.health <= 0
      @game_over.draw("Game Over FuckTard", 50, 250, 1, 1.5, 1.5, Color::RED)
    end
    
  end
end

muhny = Game_Window.new
muhny.show

