require 'Gosu'
require 'Sprite.rb'
require 'Player'
require 'Enemy'
include Gosu


class Miniboss < Enemy
  attr_accessor :x, :y, :z, :angle, :vel_x, :vel_y, :health, :max_health, :spin_speed, :bulletNum
  
  def initialize(window, sprite)
    @image = Image.new(sprite, :retro => true)
    super(window, sprite)
    @vel_x = @vel_y = @z = @angle = 0
    @health = @max_health = 200
    @x = rand(100..700)
    @y = rand(100..500)
    
    @spin = 0
    @spin_speed = 1
    @charging = true # when this is false, he shoots bullets
    @bulletTime = 180
    @bulletDelay = 5
    @bulletDelayCounter = 5
    @bulletNum = 4
    @bullets = Array.new
    
    @is_boss = true
  end
  
  def setBulletType(window, sprite)
    @bullet = Sprite.new(window, sprite)
  end
  
  def warp(x,y,z)
    @x, @y, @z = x, y, z
  end
  
  def take_dmg(dmg, wav)
    @health -= dmg
    wav.play
  end
  
  
  
  def attack(player)
    if @charging # charge toward player
      angle = Math.atan((1.0 * player.y - @y) / (player.x - @x))
      
      if player.x > @x
        angle -= Math::PI
      end
      
      @angle = (angle * 180 / Math::PI) + 90
      @vel_x = 2 * Math.cos(angle)
      @vel_y = 2 * Math.sin(angle)
    else # shoot some bullets and wander
      if @bulletTime % 60 == 0
        @vel_x = (rand * 2) - 1
        @vel_y = (rand * 2) - 1
      end
      
      if @bulletDelayCounter <= 0
        @bullet.move_to(@x,@y)
        @bulletNum.times do |i|
          @bullet.rotation = @angle + ((360 / @bulletNum) * i) - 90 + @spin
          @bullets.push(@bullet.clone)
          @spin += @spin_speed
        end
        @bulletDelayCounter = @bulletDelay
      end
    end
    @x -= @vel_x
    @y -= @vel_y
    @bullets.each_with_index {|bullet, i|
      bullet.x -= 5 * Math.cos(Math::PI * bullet.rotation / 180)
      bullet.y -= 5 * Math.sin(Math::PI * bullet.rotation / 180)
      
      @bullet.x = bullet.x
      @bullet.y = bullet.y
      if @bullet.touching? player
        player.take_damage(10)
        @bullets.delete_at(i)
      end
      
      if bullet.x <= 69 or bullet.x >= 730 or bullet.y <= 69 or bullet.y >= 530
        @bullets.delete_at(i)
      end
    }
    
    @bulletDelayCounter -= 1
  end
  
  
  def respawn
    @health = @max_health =100
    @x = rand(100..700)
    @y = rand(100..500)
    self.show
    
  end
  
  def switchPhase
    @bulletTime -= 1
    if @bulletTime <= 0
      # switch phases
      @charging = !@charging
      @bulletTime = 180
    end
  end
  
   def draw(wide, tall)
     if visible?
      @image.draw_rot(@x,@y,1,@angle, 0.5, 0.5, wide, tall) 
      
      case @health
      when (@max_health / 4)..(@max_health / 2)
        draw_rect(@x - 16, @y - 40, 32.0 * (1.0 * @health / @max_health), 2, Color::YELLOW)
      when 0..(@max_health / 4)
        draw_rect(@x - 16, @y - 40, 32.0 * (1.0 * @health / @max_health), 2, Color::RED)
      else
        draw_rect(@x - 16, @y - 40, 32.0 * (1.0 * @health / @max_health), 2, Color::GREEN)
      end
      
      @bullets.each {|bullet|
        @bullet.draw_rot(bullet.x, bullet.y, 1, bullet.rotation, 0.5, 0.5)
      }
    end
  end
end
