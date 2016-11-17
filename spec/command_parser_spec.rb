require 'rspec'
require_relative '../lib/command_parser'
require_relative '../lib/command/roll_command'
require_relative '../lib/command/block_command'
require_relative '../lib/command/bomb_command'
require_relative '../lib/command/robot_command'
require_relative '../lib/command/sell_command'
require_relative '../lib/command/sell_tool_command'

describe CommandParser do

  describe '#parse' do
    before(:each) do
      @command_parser = CommandParser.new
    end

    it 'should return roll command' do
      command = @command_parser.parse 'roll'
      expect(command).to be_an_instance_of(RollCommand)
    end

    it 'should return block command' do
      command = @command_parser.parse 'block 2'
      expect(command).to be_an_instance_of(BlockCommand)
      expect(command.steps).to eq(2)
    end

    it 'should return bomb command' do
      command = @command_parser.parse 'bomb 2'
      expect(command).to be_an_instance_of(BombCommand)
      expect(command.steps).to eq(2)
    end

    it 'should return robot command' do
      command = @command_parser.parse 'robot'
      expect(command).to be_an_instance_of(RobotCommand)
    end

    it 'should return sell command' do
      command = @command_parser.parse 'sell 2'
      expect(command).to be_an_instance_of(SellCommand)
      expect(command.position).to eq(2)
    end

    it 'should return sell tool command' do
      command = @command_parser.parse 'sellTool 2'
      expect(command).to be_an_instance_of(SellToolCommand)
      expect(command.itemIndex).to eq(2)
    end
  end
end