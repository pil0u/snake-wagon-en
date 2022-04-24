require_relative "config"

class Food
  TILE_SIZE = Config::TILE_SIZE

  def initialize(x, y)
    @x = x
    @y = y
    @image = Gosu::Image.new("./media/rabbit.png")
  end

  def self.popup
    x = rand(0...TILE_SIZE) * TILE_SIZE
    y = rand(0...TILE_SIZE) * TILE_SIZE

    Food.new(x, y)
  end

  def eaten_by?(snake)
    snake.x == @x && snake.y == @y
  end

  def draw
    # Gosu.draw_rect(@x, @y, TILE_SIZE, TILE_SIZE, Gosu::Color::RED)
    @image.draw(
      @x, @y, 0,
      scale_x=TILE_SIZE.to_f/@image.width,
      scale_y=TILE_SIZE.to_f/@image.width
    )
  end
end
