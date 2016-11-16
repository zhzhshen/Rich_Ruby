class Estate < Place
  MAX_LEVEL = 3
  attr_accessor :position, :price, :owner, :level

  def initialize(position, price)
    @position = position
    @price = price
    @level = 0
  end

  def print_map
    if @owner.nil?
      print @level
    else
      print @owner.color + @level.to_s + Color::ANSI_RESET
    end
  end

  def visit_by(player)
    if @owner.nil?
      player.execute BuyLandCommand.new self
    elsif @owner.equal? player
      player.execute BuildLandCommand.new self
    else
      player.execute ChargeLandCommand.new self
    end
  end

  def max_level?
    @level.equal? MAX_LEVEL
  end

  def build
    @level += 1
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

class BuildLandCommand
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
        if !@estate.max_level? && player.reduce_money(@estate.price)
          @estate.build
        end
    end
    player.status = Player::Status::TURN_END
  end
end

class ChargeLandCommand
  def initialize(estate)
    @estate = estate
  end

  def execute(player)
    unless @estate.owner.in_hospital? || @estate.owner.in_prison? || player.has_evisu?
      charge = 2**@estate.level * @estate.price / 2
      if (player.reduce_money charge)
        @estate.owner.gain_money charge
      else
        @estate.owner.gain_money player.money
        return player.status = Player::Status::BROKEN
      end
    end
    player.status = Player::Status::TURN_END
  end
end