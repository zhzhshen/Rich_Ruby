require 'rspec'
require_relative '../game_map'
require_relative '../starting_point'
require_relative '../estate'
require_relative '../player'
require_relative '../hospital'

describe 'player walk by item' do

  before(:each) do
    @map = GameMap.new StartingPoint.new(0), Estate.new(1, 200), Hospital.new(2)
    @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
    @game = Game.new @map, @player

    @player.startTurn

    expect(@player.position).to eq(0)
    expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
  end

  it 'should stop by block and visit place' do
    @map.put_item Block, 1
    @command = RollCommand.new lambda {2}

    @player.execute @command

    expect(@player.position).to eq(1)
    expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
  end

  it 'should stop by bomb and move to hospital' do
    @map.put_item Bomb, 1
    @command = RollCommand.new lambda {2}

    @player.execute @command

    expect(@player.position).to eq(2)
    expect(@player.in_hospital?).to eq(3)
    expect(@player.status).to eq(Player::Status::TURN_END)
  end

end