
class Mine < Place
  def initialize(position, point)
    @position = position
    @point = point
  end

  def visit_by(player)
    player.gain_point @point
    player.status = Player::Status::TURN_END
  end
end