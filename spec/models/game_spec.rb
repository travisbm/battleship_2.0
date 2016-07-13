require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game)         { create(:game) }
  let(:game_over)    { create(:game, :game_over) }
  let(:cell)         { create(:cell) }
  let(:cell_boat)    { build(:cell, :boat) }
  let(:cell_vessel)  { build(:cell, :vessel) }
  let(:cell_carrier) { build(:cell, :carrier) }
  let(:cell_invalid) { build(:cell, :invalid) }

  describe ".create" do
    it "sets a shot count" do
      expect(game.shots).to eq(Game::NUM_SHOTS)
    end

    it "sets an initial score of 0" do
      expect(game.score).to eq(0)
    end

    it "builds an ARRAY_SIZE X ARRAY_SIZE grid of cells" do
      expect(game.cells.count).to eq(Game::ARRAY_SIZE * Game::ARRAY_SIZE)
    end

    it "sets 5 boats on game board" do
      expect(game.cells.where(status: "boat").count).to eq(Boat::COUNT * Boat::SIZE)
    end

    it "sets 3 vessels on game board" do
      expect(game.cells.where(status: "vessel").count).to eq(Vessel::COUNT * Vessel::SIZE)
    end

    it "sets 2 aircraft carriers on game board" do
      expect(game.cells.where(status: "carrier").count).to eq(Carrier::COUNT * Carrier::SIZE)
    end
  end

  describe "#fire" do
    it "should change OPEN cell status to MISS" do
      expect{ game.fire(cell) }.to change(cell, :status).from(Game::OPEN).to(Game::MISS)
    end

    it "should decrement score by 50 when shot is a MISS" do
      expect{ game.fire(cell) }.to change(game, :score).by(-50)
    end

    it "should decrement shots by 1 when shot is a MISS" do
      expect{ game.fire(cell) }.to change(game, :shots).by(-1)
    end

    it "should increment score by 500 when shot is a HIT" do
      expect{ game.fire(cell_boat) }.to change(game, :score).by(500)
    end

    it "should change change BOAT cell status to HIT" do
      expect{ game.fire(cell_boat) }.to change(cell_boat, :status).from("boat").to(Game::HIT)
    end

    it "should change change VESSEL cell status to HIT" do
      expect{ game.fire(cell_vessel) }.to change(cell_vessel, :status).from("vessel").to(Game::HIT)
    end

    it "should change change CARRIER cell status to HIT" do
      expect{ game.fire(cell_carrier) }.to change(cell_carrier, :status).from("carrier").to(Game::HIT)
    end

    it "should raise 'Invalid Cell status...' when cell status is invalid" do
      expect{ game.fire(cell_invalid) }.to raise_error("Invalid Cell status...")
    end

    it "should set final score if game_over? b/c no remaining shots" do
      allow(Time).to receive(:now).and_return(game_over.created_at + 180)
      expect{ game_over.fire(cell) }.to change(game_over, :score).to(60)
    end

    it "should set final score if game_over? b/c no OPEN cells" do
      game.game_board.each { |row| row.each { |cell| cell.status = :miss } }
      allow(Time).to receive(:now).and_return(game_over.created_at + 180)
      expect{ game_over.fire(cell) }.to change(game_over, :score).to(60)
    end
  end

end
