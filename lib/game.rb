require 'gosu'

require_relative "config"
require_relative "snake"

class Game < Gosu::Window
  def initialize
    super Config::WINDOW_SIZE, Config::WINDOW_SIZE
    self.caption = "Le Wagon Snake"

    @snake = Snake.new
  end

  def update
    # ...
  end

  def draw
    @snake.draw
  end
end

