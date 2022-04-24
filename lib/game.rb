require 'gosu'

require_relative "config"
require_relative "food"
require_relative "snake"

class Game < Gosu::Window
  def initialize
    super Config::WINDOW_SIZE, Config::WINDOW_SIZE
    self.caption = "Le Wagon Snake"
    @background_image = Gosu::Image.new("./media/background.jpg", tileable: true)
    @font = Gosu::Font.new(24)

    @refresh_rate = 0.1
    @last_timestamp = Time.now

    @snake = Snake.new
    @food = Food.popup
    @score = 0
  end

  def update
    return if (Time.now - @last_timestamp) < @refresh_rate

    update_snake_direction
    @snake.move

    if @food.eaten_by?(@snake)
      # The snake grows
      @snake.grow

      # The snake speeds up
      accelerate

      # My score increases
      @score += 1

      # Some new food appears
      @food = Food.popup
    end

    if @snake.dead?
      sleep(3)

      reset_game
    end

    @last_timestamp = Time.now
  end

  def draw
    @background_image.draw(0, 0, 0)

    @snake.draw
    @food.draw

    @font.draw_text("Score: #{@score}", 10, 10, 0, 1, 1, Gosu::Color::YELLOW)
  end

  private

  def accelerate
    @refresh_rate = @refresh_rate * (1 - Config::ACCELERATION_RATE)
  end

  def reset_game
    @refresh_rate = 0.1
    @last_timestamp = Time.now

    @snake = Snake.new
    @food = Food.popup
    @score = 0
  end

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

