class Cell
  attr_accessor :status

  def initialize(row, column, status = Game::OPEN)
    @row    = row
    @column = column
    @status = status
  end
end
