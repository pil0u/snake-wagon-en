require 'gosu'

require_relative "config"
require_relative "snake"

class Game < Gosu::Window
  def initialize
    super Config::WINDOW_SIZE, Config::WINDOW_SIZE
    self.caption = "Le Wagon Snake"

    @refresh_rate = 0.1
    @last_timestamp = Time.now

    @snake = Snake.new
  end

  def update
    return if (Time.now - @last_timestamp) < @refresh_rate

    update_snake_direction
    @snake.move

    @last_timestamp = Time.now
  end

  def draw
    @snake.draw
  end

  private

  def update_snake_direction
    if Gosu.button_down?(Gosu::KB_RIGHT) && @snake.direction != "left"
      @snake.direction = "right"
    elsif Gosu.button_down?(Gosu::KB_DOWN) && @snake.direction != "up"
      @snake.direction = "down"
    elsif Gosu.button_down?(Gosu::KB_LEFT) && @snake.direction != "right"
      @snake.direction = "left"
    elsif Gosu.button_down?(Gosu::KB_UP) && @snake.direction != "down"
      @snake.direction = "up"
    end
  end
end

