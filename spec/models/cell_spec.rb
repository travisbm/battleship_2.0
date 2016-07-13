require 'rails_helper'

RSpec.describe Cell, type: :model do
  let(:cell) { create(:cell) }

  describe ".create" do
    it "initializes cell status to OPEN" do
      expect(cell.status).to eq(Game::OPEN)
    end
  end

end
