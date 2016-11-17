require_relative './place'
require_relative '../player'

class Estate < Place
  MAX_LEVEL = 3
  attr_accessor :position, :price, :owner, :level

  def initialize(position, price)
    @position = position
    @price = price
    @level = 0
  end

  def print_map
    if !@owner.nil?
      print @owner.color + @level.to_s + Player::Color::ANSI_RESET
    else
      print @level
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
    '是否购买土地? Y/N'
  end

  def respond(player, response)
    if response.upcase.eql?('N')
      message = '放弃购买土地'
    elsif response.upcase.eql?('Y')
      if !!player.reduce_money(@estate.price)
        @estate.owner = player
        message = '购买土地成功'
      else
        message = '购买土地失败'
      end
    else
      message = '放弃购买土地'
    end
    player.status = Player::Status::TURN_END
    message
  end

end

class BuildLandCommand
  def initialize(estate)
    @estate = estate
  end

  def execute(player)
    player.status = Player::Status::WAIT_FOR_RESPONSE
    '是否升级土地? Y/N'
  end

  def respond(player, response)
    if response.upcase.eql?('N')
      message = '放弃升级土地'
    elsif response.upcase.eql?('Y')
      if !@estate.max_level? && !!player.reduce_money(@estate.price)
        @estate.build
        message = '升级土地成功'
      else
        message = '升级土地失败'
      end
    else
      message = '放弃升级土地'
    end
    player.status = Player::Status::TURN_END
    message
  end
end

class ChargeLandCommand
  def initialize(estate)
    @estate = estate
  end

  def execute(player)
    unless @estate.owner.in_hospital? || @estate.owner.in_prison? || player.has_evisu?
      charge = 2**@estate.level * @estate.price / 2
      if !!player.reduce_money(charge)
        @estate.owner.gain_money charge
        player.status = Player::Status::TURN_END
        return '向' + @estate.owner.name + '付过路费' + charge.to_s + '元'
      else
        @estate.owner.gain_money player.money
        player.status = Player::Status::BROKEN
        return '余额不足以向' + @estate.owner.name + '付过路费' + charge.to_s + '元, 扑街'
      end
    end
    player.status = Player::Status::TURN_END
  end
end