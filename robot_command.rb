require './command'
class RobotCommand < Command
  def execute(player)
    if player.items.any? { |item| item.equal? ROBOT }
      player.items.delete ROBOT
      player.map.clear_items(player.location, 10)
    end
  end
end