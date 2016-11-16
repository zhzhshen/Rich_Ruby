require './roll_command'
require './block_command'
require './bomb_command'
require './robot_command'
require './sell_command'
require './sell_tool_command'

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