require 'gosu'
require 'Sprite'
require 'Player'
require 'dungen'
require 'Enemy'
require 'Axe'
require 'Health Packs'
include Gosu


DEBUGGING = true
is_dead = false


class Game_Window < Window
  def initialize
    super 800, 600
    self.caption = "Placeholder Game Name"
    @background = Image.new("bakku guroundo.png", :retro => true)
    
    @fucked = Sample.new("./deathsound2.wav")
    
    @player = Player.new(self)
    @player.warp(400,300,1)
    
    @cursor = Image.new("cursor.png", :retro => true)
    
    @font = Font.new(16, :name => "./munro.ttf")
    @game_over = Font.new(64, :name => "./munro.ttf")
   
    @num_zombies = rand(1..5)
         
    @zombies = Array.new(@num_zombies) { Enemy.new(self , "./zombie.png") }
    @zombie_damage = 4
	  @zombies_dead = 0
      
    @chainsaw = Axe.new(self, "./chainsaw.png", 4)
   
    @hpack = Health_packs.new(self)
    
    @door1 = Image.new("door1.png", :retro => true)
    @door2 = Image.new("door2.png", :retro => true)
    
    @dungeon = Dungeon.new
    @dungeon.setSize(8, 8)
    @dungeon.generate(23059)
    @dungeon.draw
    
    @player.roomx = @dungeon.spawn[0]
    @player.roomy = @dungeon.spawn[1]
    @dungeon.update(@player.roomx, @player.roomy)
  end

  @@speeed = 4
  @@gitfucked = false
  
  def update
    
    if Gosu.button_down? KB_ESCAPE
      self.close
    end
    
    #checking if the player sprite is touching a wall or going through a door
    if @player.health > 0
     if @player.x > 69
       @player.move_left(@@speeed)
     end
     
     if @player.x < 730
       @player.move_right(@@speeed)
     end    
         
     if @player.y > 69
       @player.move_up(@@speeed)
       
     end
     
     if @player.y < 530
       @player.move_down(@@speeed)  
     end
    else
      @player.warp(0, 0, 0)
      is_dead = true
      if !@@gitfucked
        @fucked.play
        @@gitfucked = true
      end
    end

    # chainsaw attack getting called while also changing the player angle depending on which direction you attacked in      
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
	        if zombie.is_visible
		        @zombies_dead +=1
		        end
	        zombie.hide
	      end
	    }
	  end

	  # check to see if all zombies are dead, and if they are, spawn a health pack
	  if (@zombies_dead >= @num_zombies)
	  	@hpack.x = 400
	  	@hpack.y = 300
	  	@hpack.show
	  	@zombies_dead = 0
	  end
	  
	  @hpack.use(@player)
	  
	  # check to see if player has gone through a door
	  if @player.x <= 69 and @player.y >= 270 and @player.y <= 295
	  	# going to the left
	  	# if player is on leftmost room or the room to the left is empty
	  	if @player.roomx == 0 or @dungeon.map[@player.roomy][@player.roomx - 1].type == 0
	  		# do nothing
	  	else
	  		# move one room to the left and update explored map
	  		@player.x = 720
	  		@player.roomx -= 1
	  		
	  		@dungeon.update(@player.roomx, @player.roomy)
	  	end
	  end
	  
	  if @player.x >= 730 and @player.y >= 270 and @player.y <= 295
	  	# going to the right
	  	# if player is on rightmost room or the room to the right is empty
	  	if @player.roomx == @dungeon.map[0].size - 1 or @dungeon.map[@player.roomy][@player.roomx + 1].type == 0
	  		# do nothing
	  	else
	  		# move one room to the right and update explored map
	  		@player.x = 79
	  		@player.roomx += 1

	  		@dungeon.update(@player.roomx, @player.roomy)
	  	end
	  end

	  if @player.y <= 69 and @player.x >= 395 and @player.x <= 420
	  	# going up
	  	# if player is on uppermost room or the room directly up is empty
	  	if @player.roomy == 0 or @dungeon.map[@player.roomy - 1][@player.roomx].type == 0
	  		# do nothing
	  	else
	  		# move one room up and update explored map
	  		@player.y = 520
	  		@player.roomy -= 1
	  		
	  		@dungeon.update(@player.roomx, @player.roomy)
	  	end
	  end
	  
	  if @player.y >= 530 and @player.x >= 395 and @player.x <= 420
	  	# going down
	  	# if player is on lowest room or the room down is empty
	  	if @player.roomy == @dungeon.map.size - 1 or @dungeon.map[@player.roomy + 1][@player.roomx].type == 0
	  		# do nothing
	  	else
	  		# move one room to the right and update explored map
	  		@player.y = 79
	  		@player.roomy += 1

	  		@dungeon.update(@player.roomx, @player.roomy)
	  	end
	  end
	  
	  
  end

  
  #####################################################
  
    
  def draw
    @background.draw(-1, -1, 0, 1, 1)
   
    if @player.health > 0
      @player.draw
    else
      
      @player.angle = 180
    end
    
    @cursor.draw(mouse_x, mouse_y, 0, 0.5, 0.5)

    @zombies.each {|zombie|
      zombie.draw
    }
    
    @door1.draw(722, 250, 0, 4, 4)
    @door1.draw(4, 250, 0, 4, 4)
    @door2.draw(375, 13, 0, 4, 4)
    @door2.draw(375, 528, 0, 4, 4)

    @chainsaw.draw
    
    @hpack.draw
    
    if DEBUGGING
      @font.draw("Mouse coords: #{mouse_x}, #{mouse_y}", 0, 0, 0)
      @font.draw("Player coords: #{@player.x}, #{@player.y}", 0, 16, 0)
      
      
     case @player.health
     when (@player.max_health/4)..(@player.max_health/2)
      @font.draw("Player health: #{@player.health}", 0, 32, 0, 1, 1, Color::YELLOW)
      when 0..(@player.max_health/4)
       @font.draw("Player health: #{@player.health}",0, 32, 0, 1, 1, Color::RED)
     else
       @font.draw("Player health: #{@player.health}",0, 32, 0, 1, 1, Color::GREEN)
     end
      
      #@font.draw("Chain saw angle: #{@chainsaw.angle}, #{@player.angle + 90}", 0, 48, 0)
      #@font.draw("Chainsaw pos: #{@chainsaw.x}, #{@chainsaw.y}", 0, 64, 0)
    end
    
    if @player.health <= 0
      @game_over.draw("omae wa mou", 135, 250, 1, 1.5, 1.5, Color::RED)
      @game_over.draw("shinde iru", 205, 314, 1, 1.5, 1.5, Color::RED)
    end
    
  end
end

muhny = Game_Window.new
muhny.show

