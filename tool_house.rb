
class ToolHouse < Place
  def visit_by(player)
    player.execute BuyToolCommand.new
    player.status = Player::Status::WAIT_FOR_RESPONSE
  end
end

class BuyToolCommand
  BLOCK_POINT = 50
  ROBOT_POINT = 30
  BOMB_POINT = 50
  class Block
    @point = BLOCK_POINT
  end

  class Robot
    @point = ROBOT_POINT
  end

  class Bomb
    @point = BOMB_POINT
  end

  def execute(player)
    player.status = Player::Status::WAIT_FOR_RESPONSE
  end

  def respond(player, response)
    case response
      when 1
        if player.reduce_point(BLOCK_POINT)
          player.items.push Block.new
          self.has_point_for_cheapest?(player) ? player.status = Player::Status::WAIT_FOR_RESPONSE : player.status = Player::Status::TURN_END
        end
      when 2
        if player.reduce_point(ROBOT_POINT)
          player.items.push Robot.new
          self.has_point_for_cheapest?(player) ? player.status = Player::Status::WAIT_FOR_RESPONSE : player.status = Player::Status::TURN_END
        end
      when 3
        if player.reduce_point(BOMB_POINT)
          player.items.push Bomb.new
          self.has_point_for_cheapest?(player) ? player.status = Player::Status::WAIT_FOR_RESPONSE : player.status = Player::Status::TURN_END
        end
      when 'n'
        player.status = Player::Status::TURN_END
    end
  end

  def has_point_for_cheapest?(player)
    player.point >= [BOMB_POINT, ROBOT_POINT, BLOCK_POINT].min
  end
end