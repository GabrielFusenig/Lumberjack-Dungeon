# Room Dungeon generator
# Code by Ryuya
# version 1.0
require 'Enemy'

class Room
	attr_accessor :type
	
	def initialize
		@type = 0
	end
	
	def setType(t)
		@type = t
	end

	def draw
		case @type
		when 1 # normal room
			print("#")
		when 2 # @spawn room
			print("@")
		when 3 # @boss room
			print("!")
		when 4 # treasure room
			print("$")
		else # empty space
			print(" ")
		end
	end
end

class Dungeon
	attr_accessor :spawn, :boss, :map, :explored, :enemies
	@spawn = [ 0, 0 ]
	@boss = [ 0, 0 ]
	  
	def createPath(rng, m, start, finish, y1, dy1)
		y = y1
		dy = dy1
		for x in start[0]..finish[0]
			if x == finish[0]
				# go to the treasure room regardless of number of remaining rooms
				if dy >= 0
					for i in y..finish[1]
						@map[i][x].setType(1)
					end
				elsif dy < 0
					for i in finish[1]..y
						@map[i][x].setType(1)
					end
				end
			else
				if dy >= 0
					targety = y + rng.rand(0..2)
					if targety > @h - 1
						targety = @h - 1
					end
					
					for i in y..targety
						@map[i][x].setType(1)
					end
					
					# update new y position
					y = targety
					dy = (finish[1] - y)
				elsif dy < 0
					targety = y - rng.rand(0..2)
					if targety < 0
						targety = 0
					end
					
					for i in targety..y
						@map[i][x].setType(1)
					end
					
					# update new y position
					y = targety
					dy = (finish[1] - y)
				end
			end
		end
	end
	
	def setSize(w, h, window, sprite)
		# array of rooms
		@map = Array.new(h) { Array.new(w) { Room.new } }
		@explored = Array.new(h) { Array.new(w) { Room.new } }
		@w = w
		@h = h
	  @enemies = Array.new(h) { Array.new(w) { Array.new(rand(1..5)) { Enemy.new(window, sprite) } } }
	end
	
	def generate(seed = 0)
		# make a PRNG
		if seed != 0
			rng = Random.new(seed)
		else
			rng = Random.new
		end
		
		
		# choose a @spawn room (x, y)
		@spawn = [ rng.rand(0..((@w / 2) - 1)), rng.rand(0..(@h - 1)) ]
		
		# try to choose a random point near the other side of the map
		@boss = [ rng.rand((@w / 2)..(@w - 1)), rng.rand(0..(@h - 1)) ]
		
		# get manhattan distance (in rooms)
		#taxi_distance = (@spawn[0] - @boss[0]).abs + (@spawn[1] - @boss[1]).abs
		
		# get a target number of rooms between @spawn and @boss
		#extra_rooms = rng.rand(0..((@w / 2) - 1)) * 2 # needs to be even
		#target_rooms = taxi_distance + extra_rooms
		
		# make a path
		#rooms = 0
		y = @spawn[1]
		dy = (@boss[1] - @spawn[1] <=> 0) # this is -1 if the number is negative, 0 if it's zero, or 1 if it's positive

		createPath(rng, @map, @spawn, @boss, y, dy)
		# add up to 4 treasure rooms
		trooms = Array.new(rng.rand(1..3)) { Array.new(2) { 0 } }
		for t in 0..trooms.size
			trooms[t] = [ rng.rand(0..(@w - 1)), rng.rand(0..(@h - 1)) ]
			#y = @spawn[1]
			dx = (trooms[t][0] - @spawn[0] <=> 0)
			dy = (trooms[t][1] - @spawn[1] <=> 0)
			
			# find a path
			if (trooms[t][0] >= @spawn[0])
				createPath(rng, @map, @spawn, trooms[t], y, dy)
			else
				y = trooms[t][1]
				createPath(rng, @map, trooms[t], @spawn, y, dy)
			end
		end
		
		
		# set trooms
		for r in trooms
			@map[r[1]][r[0]].setType(4)
		end
		
		# set @spawn room
		@map[@spawn[1]][@spawn[0]].setType(2)
		
		# set @boss room
		@map[@boss[1]][@boss[0]].setType(3)

	end
	
	def update(x, y)
		@explored[y][x] = @map[y][x]
	end
	
	def draw
		@map.each() { |row|
			row.each() { |room|
				room.draw
			}
			puts
		}
	end
	
	def draw_explored
		@explored.each() { |row|
			row.each() { |room|
				room.draw
			}
			puts
		}
	end
end

=begin
d = Dungeon.new
d.setSize(10, 10)
#puts "press enter to generate!"
#gets
d.generate
d.draw
=end
