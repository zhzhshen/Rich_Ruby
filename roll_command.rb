class RollCommand < Command
  def roll
    1
  end

  def execute(player)
    player.location = player.map.move(player, self.roll)
    player.map.place_at(player.location).visit_by player
  end

  def respond(player, response)
  end
end