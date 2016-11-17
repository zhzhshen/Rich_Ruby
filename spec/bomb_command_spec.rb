require 'rspec'
require_relative '../lib/command/bomb_command'
require_relative '../lib/place/starting_point'
require_relative '../lib/game_map'
require_relative '../lib/place/estate'
require_relative '../lib/game'

describe BombCommand do

  describe '#execute' do

    before(:each) do
      @map = GameMap.new StartingPoint.new(0), Estate.new(1, 200)
      @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
      @game = Game.new @map, @player

      @player.start_turn

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should put bomb at N steps forward' do
      @player.items.push BOMB
      expect(@player.items.size).to eq(1)

      command = BombCommand.new 1

      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(1)).to eq(BOMB)
    end

    it 'should turn end when player has no bomb' do
      command = BombCommand.new 1

      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(1)).to eq(nil)
    end

    it 'should turn end when there is another item' do
      @player.items.push BOMB
      command = BombCommand.new 1

      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(1)).to eq(BOMB)

      @player.items.push BOMB
      command = BombCommand.new 1

      @player.execute command

      expect(@player.items.size).to eq(1)
      expect(@map.item_at(1)).to eq(BOMB)
    end

    it 'should turn end when there is player' do
      @player.items.push BOMB
      expect(@player.items.size).to eq(1)
      command = BombCommand.new 0

      @player.execute command

      expect(@map.item_at(1)).to eq(nil)
      expect(@player.items.size).to eq(1)

    end

    it 'should turn end when step is further than 10' do
      @player.items.push BOMB
      expect(@player.items.size).to eq(1)
      command = BombCommand.new 11

      @player.execute command

      expect(@player.items.size).to eq(1)
      command = BombCommand.new 9

      @player.execute command

      expect(@player.items.size).to eq(0)

    end

    after(:each) do
      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end
  end
end