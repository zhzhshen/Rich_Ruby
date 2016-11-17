require 'rspec'
require_relative '../lib/command/robot_command'
require_relative '../lib/command/bomb_command'
require_relative '../lib/place/starting_point'
require_relative '../lib/game_map'
require_relative '../lib/place/estate'
require_relative '../lib/game'

describe RobotCommand do

  describe '#execute' do

    before(:each) do
      @map = GameMap.new StartingPoint.new(0), Estate.new(1, 200)
      @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
      @game = Game.new @map, @player

      @player.start_turn

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should wait for command when do not have robot' do
      expect(@player.items.size).to eq(0)

      command = RobotCommand.new

      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(0)).to eq(nil)
    end

    it 'should clear items in 10 steps when have robot' do
      @player.items.push BOMB
      expect(@player.items.size).to eq(1)

      command = BombCommand.new 1
      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(1)).to eq(BOMB)

      @player.items.push ROBOT
      expect(@player.items.size).to eq(1)
      command = RobotCommand.new
      @player.execute command

      expect(@player.items.size).to eq(0)
      expect(@map.item_at(0)).to eq(nil)
    end

    after(:each) do
      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end
  end
end