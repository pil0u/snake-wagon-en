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

    self.initialize_highscore

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
      @food.play_sound

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
      sound = @snake.play_dead_sound
      sleep(3)
      sound.stop

      if @score > @highscore
        @highscore = @score
        update_highscore(@highscore)
      end

      reset_game
    end

    @last_timestamp = Time.now
  end

  def draw
    @background_image.draw(0, 0, 0)

    @snake.draw
    @food.draw

    @font.draw_text("Score: #{@score} / High score: #{@highscore}", 10, 10, 0, 1, 1, Gosu::Color::YELLOW)
  end

  private

  def accelerate
    @refresh_rate = @refresh_rate * (1 - Config::ACCELERATION_RATE)
  end

  def initialize_highscore
    if File.exist? Config::HIGH_SCORE_PATH
      file = File.open(Config::HIGH_SCORE_PATH)
      @highscore = file.readlines.last.split(' --- ').last.to_i
      file.close
    else
      @highscore = 0
      update_highscore(@highscore)
    end
  end

  def update_highscore(score)
    file = File.new(Config::HIGH_SCORE_PATH, "a")
    file.puts("#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} --- #{score}")
    file.close
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
