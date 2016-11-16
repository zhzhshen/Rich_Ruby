
class Police < Place
  def print_map
    print 'P'
  end

  def visit_by(player)
    player.prisoned
    player.status = Player::Status::TURN_END
  end
end