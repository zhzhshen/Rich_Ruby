require 'rspec'
require_relative '../roll_command'
require_relative '../estate'

describe RollCommand do
  before(:all) do
    INITIAL_BALANCE = 1000
    ESTATE_PRICE = 200
  end

  before(:each) do
    @map = double
    @player = Player.new @map, INITIAL_BALANCE
    @player.startTurn
    @command = RollCommand.new

    expect(@player.location).to eq(0)
    expect(@command).to receive(:roll) { 1 }
    expect(@map).to receive(:move).with(@player, 1) { 1 }
  end

  describe '#execute' do
    it 'should move player to empty estate' do
      estate = Estate.new 0, ESTATE_PRICE
      allow(@map).to receive(:place_at).with(1) { estate }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

    it 'should move player to empty estate' do
      estate = Estate.new 0, ESTATE_PRICE
      estate.owner = @player
      allow(@map).to receive(:place_at).with(1) { estate }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

  end

  describe '#respond' do
    describe 'player visit empty estate' do

      before(:each) do
        @estate = Estate.new 0, ESTATE_PRICE
        allow(@map).to receive(:place_at).with(1) { @estate }

        @player.execute @command

        expect(@player.location).to eq(1)
        expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
      end

      it 'should turn end when player say no' do
        @player.respond 'n'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(INITIAL_BALANCE)
      end

      it 'should success to buy estate turn end when player say yes with enough money' do
        @player.respond 'y'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(INITIAL_BALANCE - ESTATE_PRICE)
        expect(@estate.owner).to eq(@player)
      end

      it 'should failed to buy estate turn end when player say yes without enough money' do
        @player.money = 0
        @player.respond 'y'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(0)
        expect(@estate.owner).to eq(nil)
      end
    end

    describe 'player visit own estate' do

      before(:each) do
        @estate = Estate.new 0, ESTATE_PRICE
        @estate.owner = @player
        allow(@map).to receive(:place_at).with(1) { @estate }

        @player.execute @command

        expect(@player.location).to eq(1)
        expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
      end

      it 'should turn end when player say no' do
        @player.respond 'n'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(INITIAL_BALANCE)
      end

      it 'should success to build estate turn end when player say yes with enough money' do
        @player.respond 'y'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(INITIAL_BALANCE - ESTATE_PRICE)
        expect(@estate.owner).to eq(@player)
        expect(@estate.level).to eq(1)
      end

      it 'should failed to build estate turn end when player say yes without enough money' do
        @player.money = 0
        @player.respond 'y'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(0)
        expect(@estate.owner).to eq(@player)
        expect(@estate.level).to eq(0)
      end

      it 'should failed to build estate turn end when estate max level' do
        @estate.level = 3
        @player.respond 'y'

        expect(@player.status).to eq(Player::Status::TURN_END)
        expect(@player.money).to eq(INITIAL_BALANCE)
        expect(@estate.owner).to eq(@player)
        expect(@estate.level).to eq(3)
      end

      after(:each) do
        expect(@player.status).to eq(Player::Status::TURN_END)
      end
    end
  end

end