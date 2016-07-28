require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game)         { create(:game) }
  let(:game_board)   { game.game_board.flatten }

  describe ".create" do
    it "sets a shot count" do
      expect(game.shots).to eq(Game::NUM_SHOTS)
    end

    it "sets an initial score of 0" do
      expect(game.score).to eq(0)
    end

    it "builds an ARRAY_SIZE X ARRAY_SIZE grid of cells" do
      expect(game_board.count).to eq(Game::ARRAY_SIZE * Game::ARRAY_SIZE)
    end

    it "sets 5 boats on game board" do
      boats = game_board.select do |cell|
        cell[:type] == "boat"
      end

      expect(boats.count).to eq(Boat::COUNT * Boat::SIZE)
    end

    it "sets 3 vessels on game board" do
      vessels = game_board.select do |cell|
        cell[:type] == "vessel"
      end

      expect(vessels.count).to eq(Vessel::COUNT * Vessel::SIZE)
    end

    it "sets 2 aircraft carriers on game board" do
      carriers = game_board.select do |cell|
        cell[:type] == "carrier"
      end

      expect(carriers.count).to eq(Carrier::COUNT * Carrier::SIZE)
    end
  end

  describe "#fire!" do
    let(:cell) { game.get_cell(0, 0) }

    context "cell is open" do
      before do
        cell[:status] = Game::OPEN
      end

      it "should change OPEN cell status to MISS" do
        expect{ game.fire!(0, 0) }.to change{ cell[:status] }.from(Game::OPEN).to(Game::MISS)
      end

      it "should decrement score by 50 when shot is a MISS" do
        expect{ game.fire!(0, 0) }.to change(game, :score).by(-50)
      end

      it "should decrement shots by 1 when shot is a MISS" do
        expect{ game.fire!(0, 0) }.to change(game, :shots).by(-1)
      end
    end

    context "cell is occupied" do

      context "cell is occupide by a ship" do
        before do
          cell[:status] = "ship"
        end

        it "should increment score by 500 when shot is a HIT" do
          expect{ game.fire!(0, 0) }.to change(game, :score).by(500)
        end

        it "should change change BOAT cell status to HIT" do
          expect{ game.fire!(0, 0) }.to change{ cell[:status] }.from("ship").to(Game::HIT)
        end
      end
    end

    it "should raise 'Invalid Cell status...' when cell status is invalid" do
      cell[:status] = "catamaran"
      expect{ game.fire!(0, 0) }.to raise_error("Invalid Cell status...")
    end

    context "game over" do
      before do
        cell[:status] = Game::OPEN
        allow(Time).to receive(:now).and_return(game.created_at + 180)
        game.score = 10900
      end

      it "should set final score if game_over? b/c no remaining shots" do
        game.shots = 1
        expect{ game.fire!(0, 0) }.to change(game, :score).to(60)
      end

      it "should set final score if game_over? b/c no OPEN cells" do
        game_board.each { |cell| cell[:status] = Game::MISS }
        cell[:status] = Game::OPEN
        expect{ game.fire!(0, 0) }.to change(game, :score).to(60)
      end
    end

  end

end
