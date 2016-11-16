require 'rspec'
require_relative '../sell_tool_command'

describe SellToolCommand do

  describe '#execute' do
    before(:each) do
      @map = GameMap.new StartingPoint.new(0)
      @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
      @game = Game.new @map, @player

      @player.start_turn

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should do nothing and wait for command when player have not block' do
      command = SellToolCommand.new 1

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT)
    end

    it 'should sell block and wait for command when player have block' do
      @player.items.push BLOCK
      command = SellToolCommand.new 1

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT + BLOCK_POINT)
    end

    it 'should do nothing and wait for command when player have not robot' do
      command = SellToolCommand.new 2

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT)
    end

    it 'should sell robot and wait for command when player have robot' do
      @player.items.push ROBOT
      command = SellToolCommand.new 2

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT + ROBOT_POINT)
    end

    it 'should do nothing and wait for command when player have not bomb' do
      command = SellToolCommand.new 3

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT)
    end

    it 'should sell robot and wait for command when player have bomb' do
      @player.items.push BOMB
      command = SellToolCommand.new 3

      @player.execute command

      expect(@player.point).to eq(INITIAL_POINT + BOMB_POINT)
    end

    after(:each) do
      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

  end
end