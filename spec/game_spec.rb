require 'rspec'
require_relative '../game_map'
require_relative '../game'
require_relative '../starting_point'
require_relative '../player'

describe Game do
  it '#initialize' do
    @map = GameMap.new StartingPoint.new 0
    @player = Player.new @map, 0, 0
    @game = Game.new @map, @player

    expect(@map.player_at(0)).to eq(@player)
  end
end