require_relative './command/roll_command'
require_relative './command/block_command'
require_relative './command/bomb_command'
require_relative './command/robot_command'
require_relative './command/sell_command'
require_relative './command/sell_tool_command'

class CommandParser
  def parse(command_string)
    commands = command_string.split(' ')
    case commands[0].downcase
      when 'roll'
        RollCommand.new
      when 'block'
        BlockCommand.new commands[1].to_i
      when 'bomb'
        BombCommand.new commands[1].to_i
      when 'robot'
        RobotCommand.new
      when 'sell'
        SellCommand.new commands[1].to_i
      when 'selltool'
        SellToolCommand.new commands[1].to_i
    end
  end
end