require './command'
class RobotCommand < Command
  def execute(player)
    if player.items.any? { |item| item.equal? ROBOT }
      player.items.delete ROBOT
      player.map.clear_items(player.position, 10)
      '使用机器人成功'
    end
  end
end