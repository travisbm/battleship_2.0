class Game < ActiveRecord::Base
  serialize :game_board, Array
  before_create :init

  ARRAY_SIZE = 10
  OPEN       = :open
  HIT        = :hit
  MISS       = :miss
  BOAT       = Ship.new(1, :boat,    5)
  VESSEL     = Ship.new(3, :vessel,  3)
  CARRIER    = Ship.new(5, :carrier, 2)
  SHIP_ARRAY = [BOAT, VESSEL, CARRIER]

  def init
    self.score      = 0
    self.shots      = 50
    self.game_board = init_game_board
    set_game_board(SHIP_ARRAY)
  end

  def print_board
    width = 8
    puts "Score: #{@score}\nShots: #{@shots}"
    self.game_board.map { |arr| arr.map { |cell| cell.status.to_s.rjust(width) }.join(" ") }
  end

  def fire(cell)
    status = cell.status

    case status
    when OPEN                        then update_game_when_miss(cell)
    when *[:boat, :vessel, :carrier] then update_game_when_hit(cell)
    else                             raise "Invalid Cell status..."
    end

    return set_final_score if game_over?
  end

  private

  def game_over?
    self.shots <= 0 || self.game_board.each { |arr| arr.each { |cell| cell.status != OPEN  } }.none?
  end

  def set_final_score
    self.score = (self.score / (Time.now - self.created_at)).floor
  end

  def update_game_when_miss(cell)
    cell.status = MISS
    self.score -= 50
    self.shots -= 1
  end

  def update_game_when_hit(cell)
    cell.status = HIT
    self.score += 500
  end

  def available_ship_positions(array, ship_size)
    available_positions = []

    array.each           { |arr| arr.each_cons(ship_size) { |arr| available_positions << arr if arr.all? { |cell| cell.status == OPEN } } }
    array.transpose.each { |arr| arr.each_cons(ship_size) { |arr| available_positions << arr if arr.all? { |cell| cell.status == OPEN } } }

    available_positions
  end

  def place_ship(array, ship_type)
    ship_array = array.sample
    ship_array.each { |cell| cell.status = ship_type }
  end

  def set_game_board(ship_array)
    ship_array.each do |ship_type|
      ship_type.count.times { place_ship(available_ship_positions(self.game_board, ship_type.size), ship_type.type) }
    end
  end

  def init_game_board
    Array.new(ARRAY_SIZE) { |row| Array.new(ARRAY_SIZE) { |column| Cell.new(row, column) } }
  end
end
