require 'rspec'
require_relative '../lib/command/sell_command'

describe SellCommand do

  describe '#execute' do
    before(:each) do
      @estate = Estate.new(1, 200)
      @map = GameMap.new StartingPoint.new(0), @estate
      @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
      @game = Game.new @map, @player

      @player.start_turn

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should do nothing and wait for command if invalid number' do
      command = SellCommand.new 2

      @player.execute command

      expect(@player.money).to eq(INITIAL_BALANCE)
    end

    it 'should do nothing and wait for command if others estate' do
      @estate.owner = double

      command = SellCommand.new 1

      @player.execute command

      expect(@player.money).to eq(INITIAL_BALANCE)
    end

    it 'should do nothing and wait for command if empty estate' do
      command = SellCommand.new 1

      @player.execute command

      expect(@player.money).to eq(INITIAL_BALANCE)
    end

    it 'should success to sell estate and wait for command if own estate level 0' do
      @estate.owner = @player
      command = SellCommand.new 1

      @player.execute command

      expect(@player.money).to eq(INITIAL_BALANCE + @estate.price)
      expect(@estate.owner).to eq(nil)
      expect(@estate.level).to eq(0)
    end

    it 'should success to sell estate and wait for command if own estate level 3' do
      @estate.level = 3
      @estate.owner = @player
      command = SellCommand.new 1

      @player.execute command

      expect(@player.money).to eq(INITIAL_BALANCE + @estate.price * 8)
      expect(@estate.owner).to eq(nil)
      expect(@estate.level).to eq(0)
    end
  end
end