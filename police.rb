
class Police < Place
  def visit_by(player)
    player.prisoned
    player.status = Player::Status::TURN_END
  end
end