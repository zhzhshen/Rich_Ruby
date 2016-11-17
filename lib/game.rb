
class Game
  def initialize(map, *players)
    @map = map
    @players = players
    players.each {|player| @map.players.push player}
    @current_player = 0
  end

  def start_turn
    current_player.start_turn
    if current_player.status.equal? Player::Status::TURN_END
      end_turn
      start_turn
    end
  end

  def end_turn
    if @current_player.equal? (@players.size - 1)
      @current_player = 0
    else
      @current_player += 1
    end
  end

  def current_player
    @players[@current_player]
  end
end