
class Place

  attr_accessor :position

  def initialize(position)
    @position = position
  end

  def visit_by(player)
    player.status = Player::Status::TURN_END
  end
end