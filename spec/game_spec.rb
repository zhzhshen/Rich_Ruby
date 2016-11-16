require 'rspec'
require_relative '../game_map'
require_relative '../game'
require_relative '../starting_point'
require_relative '../player'
require_relative '../roll_command'

describe Game do
  describe '#initialize' do
    it 'should have player at starting point' do
      @map = GameMap.new StartingPoint.new 0
      @player = Player.new @map, 0, 0
      @game = Game.new @map, @player

      expect(@map.player_at(0)).to eq(@player)
    end
  end

  describe '#start turn' do
    before(:each) do
      @map = GameMap.new StartingPoint.new(0), Hospital.new(1)
      @player1 = Player.new @map, 0, 0
      @player2 = Player.new @map, 0, 0
      @game = Game.new @map, @player1, @player2

      @game.start_turn

      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@game.current_player).to eq(@player1)
    end

    it 'should have first user wait for command' do
      @player1.execute RollCommand.new lambda {1}

      expect(@player1.status).to eq(Player::Status::TURN_END)

      @game.end_turn

      expect(@game.current_player).to eq(@player2)
      expect(@player2.status).to eq(Player::Status::TURN_END)

      @game.start_turn

      expect(@player2.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should skip three turns when in hospital' do
      @player2.burn
      expect(@player2.position).to eq(1)
      expect(@player2.in_hospital?).to eq(3)

      @player1.execute RollCommand.new lambda {1}
      expect(@player1.status).to eq(Player::Status::TURN_END)

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player1)
      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@player2.status).to eq(Player::Status::TURN_END)
      expect(@player2.in_hospital?).to eq(2)

      @player1.execute RollCommand.new lambda {1}

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player1)
      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@player2.status).to eq(Player::Status::TURN_END)
      expect(@player2.in_hospital?).to eq(1)

      @player1.execute RollCommand.new lambda {1}

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player1)
      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@player2.status).to eq(Player::Status::TURN_END)
      expect(@player2.in_hospital?).to eq(nil)

      @player1.execute RollCommand.new lambda {1}

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player2)
      expect(@player1.status).to eq(Player::Status::TURN_END)
      expect(@player2.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should skip two turns when in prison' do
      @player2.prisoned
      expect(@player2.position).to eq(1)
      expect(@player2.in_hospital?).to eq(2)

      @player1.execute RollCommand.new lambda {1}
      expect(@player1.status).to eq(Player::Status::TURN_END)

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player1)
      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@player2.status).to eq(Player::Status::TURN_END)
      expect(@player2.in_hospital?).to eq(1)

      @player1.execute RollCommand.new lambda {1}

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player1)
      expect(@player1.status).to eq(Player::Status::WAIT_FOR_COMMAND)
      expect(@player2.status).to eq(Player::Status::TURN_END)
      expect(@player2.in_hospital?).to eq(nil)

      @player1.execute RollCommand.new lambda {1}

      @game.end_turn
      @game.start_turn

      expect(@game.current_player).to eq(@player2)
      expect(@player1.status).to eq(Player::Status::TURN_END)
      expect(@player2.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end
  end
end