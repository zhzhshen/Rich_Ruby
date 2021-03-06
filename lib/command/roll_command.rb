require_relative './command'
class RollCommand < Command

  def initialize(dice = lambda {1 + rand(6)})
    @dice = dice
  end

  def roll
    @dice.call
  end

  def execute(player)
    player.position = player.map.move(player, self.roll)
    player.map.place_at(player.position).visit_by player
  end

end