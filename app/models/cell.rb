class Cell < ActiveRecord::Base
  belongs_to    :game
  before_create :init

  def init
    self.status ||= Game::OPEN
  end
end
