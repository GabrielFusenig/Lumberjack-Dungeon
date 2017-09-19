#require 'gosu'
#include Gosu


class Room
	@type = 0
	def setType(t)
		# array of tiles
		#@map = Array.new(h) { Array.new(w) { 0 } }
		@type = t
	end

	def draw
		#@map.each() { |tile|
		#	tile.print
		#}
		case @type
		when 1 # normal room
			print("#")
		when 2 # spawn room
			print("@")
		when 3 # boss room
			print("!")
		else # empty space
			print(" ")
		end
	end
end

class Dungeon
	
	def setSize(w, h)
		# array of rooms
		@map = Array.new(h) { Array.new(w) { Room.new } }
		@w = w
		@h = h
	end
	
	def generate(seed = 0)
		# make a PRNG
		if seed != 0
			rng = Random.new(seed)
		else
			rng = Random.new
		end
		
		
		# choose a spawn room (x, y)
		spawn = [ rng.rand(0..((@w / 2) - 1)), rng.rand(0..(@h - 1)) ]
		
		# try to choose a random point near the other side of the map
		boss = [ rng.rand((@w / 2)..(@h - 1)), rng.rand(0..(@h - 1)) ]
		
		# get manhattan distance (in rooms)
		taxi_distance = (spawn[0] - boss[0]).abs + (spawn[1] - boss[1]).abs
		
		# get a target number of rooms between spawn and boss
		extra_rooms = rng.rand(0..((@w / 2) - 1)) * 2 # needs to be even
		target_rooms = taxi_distance + extra_rooms
		
		# make a path
		rooms = 0
		y = spawn[1]
		dy = (boss[1] - spawn[1] <=> 0) # this is -1 if the number is negative, 0 if it's zero, or 1 if it's positive
		for x in spawn[0]..boss[0]
			if x == boss[0]
				# go to the boss room regardless of number of remaining rooms
				if dy >= 0
					for i in y..boss[1]
						@map[i][x].setType(1)
					end
				elsif dy < 0
					for i in boss[1]..y
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
					dy = (boss[1] - y)
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
					dy = (boss[1] - y)
				end
			end
		end
		
		# add a treasure room
		troom = [ rng.rand(0..(@w - 1)), rng.rand(0..(@h - 1)) ]
		
		
		# set spawn room
		@map[spawn[1]][spawn[0]].setType(2)
		
		# set boss room
		@map[boss[1]][boss[0]].setType(3)

	end
	
	def draw
		@map.each() { |row|
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
