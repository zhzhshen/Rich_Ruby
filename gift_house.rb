
class GiftHouse < Place
  def visit_by(player)
    player.execute ChooseGiftCommand.new
  end
end

class ChooseGiftCommand
  GIFT_MONEY = 2000
  GIFT_POINT = 200
  def execute(player)
    player.status = Player::Status::WAIT_FOR_RESPONSE
  end

  def respond(player, response)
    case response
      when 1
        player.gain_money GIFT_MONEY
      when 2
        player.gain_point GIFT_POINT
      when 3
        player.evisu
    end
    player.status = Player::Status::TURN_END
  end
end