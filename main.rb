require 'gosu'
require 'Sprite'
require 'Player'
require 'dungen'
require 'Enemy'
require 'Axe'
require 'Health Packs'
require 'Miniboss'
include Gosu


DEBUGGING = true
is_dead = false


class Game_Window < Window
  def initialize
    super 800, 600
    self.caption = "Lumberjack Dungeon"
    @background = Image.new("bakku guroundo.png", :retro => true)
    #@menu = Image.new("")
    
    @fucked = Sample.new("./deathsound2.wav")
    @grrrrrrr = Sample.new("./chainsaw_noise.wav")
    @grrrrrrr_counter = 0
    @muhny = Sample.new("./zombiedmg.wav")

    # bgm
    @explore_intro = Song.new("./th11_04_intro.wav")
    @explore_loop = Song.new("./th11_04_loop.wav")
    @miniboss_intro = Song.new("./th11_03_intro.wav")
    @miniboss_loop = Song.new("./th11_03_loop.wav")
    @boss_intro = Song.new("./th10_11_intro.wav")
    @boss_loop = Song.new("./th10_11_loop.wav")
    
    @score = 0
    
    @player = Player.new(self)
    @player.warp(400,300,1)
    
    @cursor = Image.new("cursor.png", :retro => true)
    
    @font = Font.new(16, :name => "./munro.ttf")
    @game_over = Font.new(64, :name => "./munro.ttf")
   
    @num_zombies = rand(1..5)
    
    @zombies = Array.new(@num_zombies) { Enemy.new(self , "./zombie.png") }
    @zombie_damage = 2
	  @zombies_dead = 0
	  
    #@mboss = Miniboss.new(self,"./furry boi.png")
    #@mboss.setBulletType(self, "./shuriken.png")
	   
    @chainsaw = Axe.new(self, "./chainsaw.png", 2)
   
    @hpack = Health_packs.new(self)
    
    @door1 = Image.new("door1.png", :retro => true)
    @door2 = Image.new("door2.png", :retro => true)
    
    @dungeon = Dungeon.new
    @dungeon.setSize(8, 8, self, "./zombie.png")
    #@dungeon.generate(23059)
    @dungeon.generate(458)
    @dungeon.spawnBosses(self, "./furry boi.png", "./shuriken.png")
    @dungeon.draw
    
    @player.roomx = @dungeon.spawn[0]
    @player.roomy = @dungeon.spawn[1]
    @dungeon.update(@player.roomx, @player.roomy)
    
    @minimap = true
    
    @main_menu = 0
    @game = 1
    @game_state = @main_menu
  end

  @@speeed = 4
  @@gitfucked = false
  
  def button_down(id)
    case id
    when KB_M
      @minimap = !@minimap
    when MsLeft
      if mouse_x >= 350 && mouse_x <= 450 && mouse_y >= 400 && mouse_y <= 460
        @game_state = @game
        @explore_intro.play
      end
    end
		
  end
  
  def update
    
    if Gosu.button_down? KB_ESCAPE
      self.close
    end
    
    case @game_state
    when @main_menu
      #draw the menu screen
    when @game

      # update bgm
      case @dungeon.map[@player.roomy][@player.roomx].type
      when 1..2 # exploring music
        if !@explore_intro.playing? and Song.current_song != @explore_loop
          @explore_loop.play
        end
      when 3 # boss music
        if !@boss_intro.playing? and Song.current_song != @boss_loop
          @boss_loop.play
        end
      when 4 # miniboss music
        if !@miniboss_intro.playing? and Song.current_song != @miniboss_loop
          @miniboss_loop.play
        end
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
      @grrrrrrr_counter -= 1
      if Gosu.button_down? KbI
        @player.angle = 270
        if @grrrrrrr_counter <= 0
          @grrrrrrr.play
          @grrrrrrr_counter = 5
        end     
      elsif Gosu.button_down? KbK
        @player.angle = 90
        if @grrrrrrr_counter <= 0
          @grrrrrrr.play
          @grrrrrrr_counter = 5
        end
      elsif Gosu.button_down? KbJ
        @player.angle = 180
        if @grrrrrrr_counter <= 0
          @grrrrrrr.play
          @grrrrrrr_counter = 5
        end
      elsif Gosu.button_down? KbL
        @player.angle = 0
        if @grrrrrrr_counter <= 0
          @grrrrrrr.play
          @grrrrrrr_counter = 5
        end
      end
      
       
  	  unless @player.health <= 0
  	    @dungeon.enemies[@player.roomy][@player.roomx].each {|zombie|
  	      @chainsaw.axe(zombie, @muhny)
  	      zombie.attack(@player)
  	      if zombie.touching?(@player)
  	        @player.take_damage(@zombie_damage)
  	      end
  	      
  	      if zombie.is_boss
  	      	zombie.switchPhase
  	      end
  	      
  	      if zombie.health <= 0
  	        if zombie.is_visible
  		        @zombies_dead +=1
              @score += 1
              
              if @score % 20 == 0
                @player.max_health += 20
                @player.health += 20
              end
              
              if @score % 30 == 0 and @score <= 60
                @chainsaw.dmg += 1
              end
  		      end
  	        zombie.hide
  	      end
  	    }
  	    
  	  end
  	  
=begin
  	  if @dungeon.map[@player.roomy][@player.roomx].type == 4
        unless @mboss.health <= 0
    	    @mboss.attack(@player)
          @mboss.switchPhase
    	    @chainsaw.axe(@mboss, @muhny)
        end
  	  end
  	  
  	  if @mboss.health <= 0
        if @mboss.visible?
          @zombies_dead += 1
        end
  	    @mboss.hide
  	    
  	  else
  	    @mboss.show
  	  end
=end
  	  
  	  # check to see if all zombies are dead, and if they are, spawn a health pack
      if @dungeon.map[@player.roomy][@player.roomx].type == 4
        if (@zombies_dead >= @dungeon.enemies[@player.roomy][@player.roomx].size + 1)
    	  	@hpack.x = 400
    	  	@hpack.y = 300
    	  	@hpack.show
    	  	@zombies_dead = 0
    	  end
      else
        if (@zombies_dead >= @dungeon.enemies[@player.roomy][@player.roomx].size)
          @hpack.x = 400
          @hpack.y = 300
          @hpack.show
          @zombies_dead = 0
        end
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
					if @dungeon.map[@player.roomy][@player.roomx].type != @dungeon.map[@player.roomy][@player.roomx - 1].type
						case @dungeon.map[@player.roomy][@player.roomx - 1].type
						when 1..2
							Song.current_song.stop
							@explore_intro.play
						when 3
							Song.current_song.stop
							@boss_intro.play
						when 4
							Song.current_song.stop
							@miniboss_intro.play
						end
					end
					
  	  		@player.x = 720
  	  		@player.roomx -= 1
  	  		
  	  		@dungeon.update(@player.roomx, @player.roomy)
          @zombies_dead = 0
  	  	end
  	  end
  	  
  	  if @player.x >= 730 and @player.y >= 270 and @player.y <= 295
  	  	# going to the right
  	  	# if player is on rightmost room or the room to the right is empty
  	  	if @player.roomx == @dungeon.map[0].size - 1 or @dungeon.map[@player.roomy][@player.roomx + 1].type == 0
  	  		# do nothing
  	  	else
  	  		# move one room to the right and update explored map
					if @dungeon.map[@player.roomy][@player.roomx].type != @dungeon.map[@player.roomy][@player.roomx + 1].type
						case @dungeon.map[@player.roomy][@player.roomx + 1].type
						when 1..2
							Song.current_song.stop
							@explore_intro.play
						when 3
							Song.current_song.stop
							@boss_intro.play
						when 4
							Song.current_song.stop
							@miniboss_intro.play
						end
					end
				
  	  		@player.x = 79
  	  		@player.roomx += 1
  
  	  		@dungeon.update(@player.roomx, @player.roomy)
  	  		@zombies_dead = 0
  	  	end
  	  end
  
  	  if @player.y <= 69 and @player.x >= 395 and @player.x <= 420
  	  	# going up
  	  	# if player is on uppermost room or the room directly up is empty
  	  	if @player.roomy == 0 or @dungeon.map[@player.roomy - 1][@player.roomx].type == 0
  	  		# do nothing
  	  	else
  	  		# move one room up and update explored map
					if @dungeon.map[@player.roomy][@player.roomx].type != @dungeon.map[@player.roomy - 1][@player.roomx].type
						case @dungeon.map[@player.roomy - 1][@player.roomx].type
						when 1..2
							Song.current_song.stop
							@explore_intro.play
						when 3
							Song.current_song.stop
							@boss_intro.play
						when 4
							Song.current_song.stop
							@miniboss_intro.play
						end
					end
					
  	  		@player.y = 520
  	  		@player.roomy -= 1
  	  		
  	  		@dungeon.update(@player.roomx, @player.roomy)
          @zombies_dead = 0
  	  	end
  	  end
  	  
  	  if @player.y >= 530 and @player.x >= 395 and @player.x <= 420
  	  	# going down
  	  	# if player is on lowest room or the room down is empty
  	  	if @player.roomy == @dungeon.map.size - 1 or @dungeon.map[@player.roomy + 1][@player.roomx].type == 0
  	  		# do nothing
  	  	else
  	  		# move one room to the right and update explored map
					if @dungeon.map[@player.roomy][@player.roomx].type != @dungeon.map[@player.roomy + 1][@player.roomx].type
						case @dungeon.map[@player.roomy + 1][@player.roomx].type
						when 1..2
							Song.current_song.stop
							@explore_intro.play
						when 3
							Song.current_song.stop
							@boss_intro.play
						when 4
							Song.current_song.stop
							@miniboss_intro.play
						end
					end
					
  	  		@player.y = 79
  	  		@player.roomy += 1
  
  	  		@dungeon.update(@player.roomx, @player.roomy)
          @zombies_dead = 0
  	  	end
  	  end
  	  
  	  
  	end
  end

  
  #####################################################
  
    
  def draw
    case @game_state
    when @main_menu
      #draw the menu screen
      @game_over.draw("Lumberjack Dungeon", 115, 50, 1, 1.3, 1.3, Color::WHITE)
      
      @game_over.draw("Play", 365, 400, 1, 0.75, 0.75, Color::WHITE)
      
      if mouse_x >= 350 && mouse_x <= 450 && mouse_y >= 400 && mouse_y <= 460
        draw_rect(348, 396, 4, 58, Color::WHITE, 1)
        draw_rect(450, 396, 4, 58, Color::WHITE, 1)
        draw_rect(350, 396, 100, 4, Color::WHITE, 1)
        draw_rect(350, 450, 100, 4, Color::WHITE, 1)
      end
      
    when @game
      
      @background.draw(-1, -1, 0, 1, 1)

      @dungeon.enemies[@player.roomy][@player.roomx].each {|zombie|
      	zombie.draw(1.5, 1.5)
        #draw_rect(zombie.x - (zombie.width / 2), zombie.y - (zombie.height / 2), zombie.width, zombie.height, Color::RED, 1)
      }
      
      #if @dungeon.map[@player.roomy][@player.roomx].type == 4
      #  @mboss.draw(2.3, 2.3)
      #end
      
      @font.draw("Score: #{@score}", 750, 0, 0, 1, 1)
      
      @door1.draw(722, 250, 0, 4, 4)
      @door1.draw(4, 250, 0, 4, 4)
      @door2.draw(375, 13, 0, 4, 4)
      @door2.draw(375, 528, 0, 4, 4)
  
      @chainsaw.draw
      
      @hpack.draw
      
      # draw minimap
      if @minimap
  			draw_rect(596, 0, 204, 204, Color.rgba(50, 50, 50, 100))
  	    @dungeon.explored.each_with_index { |row, i|
  	    	row.each_with_index { |room, j|
  	    		width = 200.0 / row.size
  	    		height = 200.0 / @dungeon.explored.size
  					case room.type
  					when 1 # normal room
  						draw_rect(600 + (j * width), 2 + (i * height), width, height, Color.rgba(206, 206, 206, 255))
  					when 2 # @spawn room
  						draw_rect(600 + (j * width), 2 + (i * height), width, height, Color::BLUE)
  					when 3 # @boss room
  						draw_rect(600 + (j * width), 2 + (i * height), width, height, Color::BLACK)
  					when 4 # treasure room
  						draw_rect(600 + (j * width), 2 + (i * height), width, height, Color.rgba(253, 240, 60, 255))
  					else # empty space
  					end
  					
  					# draw outline on room that player is in
  					if i == @player.roomy and j == @player.roomx
  						draw_rect(600 + (j * width), (i * height), width, 2, Color::GREEN, 1)
  						draw_rect(600 + (j * width), 2 + ((i + 1) * height), width, 2, Color::GREEN, 1)
  						draw_rect(598 + (j * width), 2 + (i * height), 2, height, Color::GREEN, 1)
  						draw_rect(600 + ((j + 1) * width), 2 + (i * height), 2, height, Color::GREEN, 1)
  					end
  	    	}
  	    }
  	  end
      
      # draw temp bounding box
  	  #draw_rect(@player.x - (@player.width / 2), @player.y - (@player.height / 2), @player.width, @player.height, Color::RED, 1)
  	  #draw_rect(@chainsaw.x - (@chainsaw.width / 2), @chainsaw.y - (@chainsaw.height / 2), @chainsaw.width, @chainsaw.height, Color::RED, 1)
      
      if @player.health > 0
        @player.draw
      else
        @player.angle = 180
      end
  
     
      
   
        
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
     
      
      if @player.health <= 0
        @game_over.draw("omae wa mou", 135, 250, 1, 1.5, 1.5, Color::RED)
        @game_over.draw("shinde iru", 205, 314, 1, 1.5, 1.5, Color::RED)
      end
    
    #when end  
    end
    @cursor.draw(mouse_x, mouse_y, 1, 0.5, 0.5)
  
    if DEBUGGING
      @font.draw("Mouse coords: #{mouse_x}, #{mouse_y}", 0, 0, 0)
      @font.draw("Player coords: #{@player.x}, #{@player.y}", 0, 16, 0)
    end
     
    #draw end
  end

  #class end
end

muhny = Game_Window.new
muhny.show

