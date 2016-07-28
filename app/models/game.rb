class Game < ActiveRecord::Base
  serialize     :game_board, Array
  before_create :init

  ARRAY_SIZE = 10
  NUM_SHOTS  = 50
  SCORE_HIT  = 500
  SCORE_MISS = 50
  OPEN       = "open"
  HIT        = "hit"
  MISS       = "miss"
  BOAT       = Boat.new
  VESSEL     = Vessel.new
  CARRIER    = Carrier.new
  SHIP_ARRAY = [BOAT, VESSEL, CARRIER]
  SHIP_COUNT = []

  def fire!(row, col)
    cell = get_cell(row, col)

    case cell[:status]
    when OPEN   then update_game_when_miss(cell)
    when "ship" then update_game_when_hit(cell)
    else        raise "Invalid Cell status..."
    end

    set_final_score if game_over?
  end

  def get_cell(row, col)
    game_board[row][col]
  end

  private

  def update_ship_count
    self.update(boats:    ship_count("boat"))
    self.update(vessels:  ship_count("vessel"))
    self.update(carriers: ship_count("carrier"))
  end

  def ship_count(type)
    SHIP_COUNT.count do |arr|
      arr.any? do |hash|
        cell = get_cell(hash[:row], hash[:column])
        cell[:type] == type && cell[:status] == "ship"
      end
    end
  end

  def init
    self.boats    ||= 5
    self.vessels  ||= 3
    self.carriers ||= 2
    self.score    ||= 0
    self.shots    ||= NUM_SHOTS
    self.game_board = init_game_board
    set_game_board
  end

  def game_over?
    self.shots <= 0 || no_playable_cells?
  end

  def no_playable_cells?
    self.game_board.flatten.none? do |cell|
      cell[:status] == "ship"
    end
  end

  def set_final_score
    self.update(score: (self.score / (Time.now - self.created_at)).floor)
  end

  def update_game_when_miss(cell)
    cell[:status] = MISS
    self.update(score: (self.score - SCORE_MISS), shots: (self.shots - 1))
  end

  def update_game_when_hit(cell)
    cell[:status] = HIT
    self.update(score: (self.score + SCORE_HIT))
    update_ship_count
  end

  def available_ship_positions(array, ship_size)
    available_positions = []

    array.each           { |arr| arr.each_cons(ship_size) { |arr| available_positions << arr if arr.all? { |cell| cell[:status] == OPEN } } }
    array.transpose.each { |arr| arr.each_cons(ship_size) { |arr| available_positions << arr if arr.all? { |cell| cell[:status] == OPEN } } }

    available_positions
  end

  def place_ship(array, ship_type)
    ship_array = array.sample
    SHIP_COUNT << ship_array
    ship_array.each do |cell|
      cell[:status] = "ship"
      cell[:type]   = ship_type
    end
  end

  def set_game_board
    SHIP_ARRAY.each do |ship|
      ship.count.times { place_ship(available_ship_positions(self.game_board, ship.size), ship.type) }
    end
  end

  def init_game_board
    Array.new(ARRAY_SIZE) { |row| Array.new(ARRAY_SIZE) { |column| { status: OPEN, row: row, column: column, type: ''} } }
  end
end
