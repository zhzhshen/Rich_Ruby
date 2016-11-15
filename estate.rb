
class Estate

  attr_accessor :position, :price, :owner

  def initialize(position, price)
    @position = position
    @price = price
  end

  def visit_by(player)
    player.execute BuyLandCommand.new self
  end

end

class BuyLandCommand
  def initialize(estate)
    @estate = estate
  end

  def execute(player)
    player.status = Player::Status::WAIT_FOR_RESPONSE
  end

  def respond(player, response)
    case response.upcase
      when 'N'
      when 'Y'
        if player.reduce_money @estate.price
          @estate.owner = player
        end
    end
    player.status = Player::Status::TURN_END
  end

end

