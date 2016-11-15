
class Game
  def initialize(map, *players)
    @map = map
    @players = players
    players.each {|player| @map.players.push player}
  end
end