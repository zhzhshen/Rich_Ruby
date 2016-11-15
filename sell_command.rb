require './command'
class SellCommand < Command
  def initialize(position)
    @position = position
  end

  def execute(player)
    place = player.map.place_at(@position)
    if place.nil?
      return
    end
    if place.instance_variable_defined?(:@owner) && place.owner.equal?(player)
      player.gain_money 2**place.level * place.price
      place.owner = nil
      place.level = 0
    end
  end
end