require 'rspec'
require_relative '../roll_command'
require_relative '../place'
require_relative '../estate'
require_relative '../starting_point'
require_relative '../gift_house'
require_relative '../magic_house'
require_relative '../hospital'

describe RollCommand do
  before(:all) do
    INITIAL_BALANCE = 1000
    INITIAL_POINT = 0
    ESTATE_PRICE = 200
  end

  before(:each) do
    @map = double
    @player = Player.new @map, INITIAL_BALANCE, INITIAL_POINT
    @player.startTurn
    @command = RollCommand.new

    expect(@player.location).to eq(0)
    expect(@command).to receive(:roll) { 1 }
    expect(@map).to receive(:move).with(@player, 1) { 1 }
  end

  describe '#execute' do
    it 'should move player to empty estate then wait for response' do
      estate = Estate.new 0, ESTATE_PRICE
      allow(@map).to receive(:place_at).with(1) { estate }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

    it 'should move player to own estate then wait for response' do
      estate = Estate.new 0, ESTATE_PRICE
      estate.owner = @player
      allow(@map).to receive(:place_at).with(1) { estate }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

    it 'should move player to others estate then turn end' do
      estate = Estate.new 0, ESTATE_PRICE
      estate.owner = Player.new @map, 0, 0
      allow(@map).to receive(:place_at).with(1) { estate }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::TURN_END)
    end

    it 'should move player to starting point then turn end' do
      starting_point = StartingPoint.new 0
      allow(@map).to receive(:place_at).with(1) { starting_point }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::TURN_END)
    end

    it 'should move player to gift house then wait for response' do
      gift_house = GiftHouse.new 0
      allow(@map).to receive(:place_at).with(1) { gift_house }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

    it 'should move player to magic house then wait turn end' do
      magic_house = MagicHouse.new 0
      allow(@map).to receive(:place_at).with(1) { magic_house }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::TURN_END)
    end

    it 'should move player to hospital then wait turn end' do
      hospital = Hospital.new 0
      allow(@map).to receive(:place_at).with(1) { hospital }

      @player.execute @command

      expect(@player.location).to eq(1)
      expect(@player.status).to eq(Player::Status::TURN_END)
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

    describe 'player visit others estate' do

      before(:each) do
        @estate = Estate.new 0, ESTATE_PRICE
        @estate.owner = Player.new @map, 0, 0
        allow(@map).to receive(:place_at).with(1) { @estate }
      end

      it 'should pay half estate price then turn end when level 0' do
        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE - ESTATE_PRICE / 2)
        expect(@estate.owner.money).to eq(ESTATE_PRICE / 2)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should pay estate price then turn end when level 1' do
        @estate.level = 1

        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE - ESTATE_PRICE)
        expect(@estate.owner.money).to eq(ESTATE_PRICE)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should pay four times of estate price then turn end when level 3' do
        @estate.level = 3

        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE - ESTATE_PRICE * 4)
        expect(@estate.owner.money).to eq(ESTATE_PRICE * 4)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should not pay then turn end when owner is in hospital' do
        @estate.owner.burn

        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE)
        expect(@estate.owner.money).to eq(0)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should not pay then turn end when owner is in prison' do
        @estate.owner.prisoned

        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE)
        expect(@estate.owner.money).to eq(0)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should not pay then turn end when player has evisu' do
        @player.evisu

        @player.execute @command

        expect(@player.money).to eq(INITIAL_BALANCE)
        expect(@estate.owner.money).to eq(0)
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

      it 'should broke when player has no enough money to pay' do
        @player.money = 0

        @player.execute @command

        expect(@player.money).to eq(0)
        expect(@estate.owner.money).to eq(0)
        expect(@player.status).to eq(Player::Status::BROKEN)
      end

    end

    describe 'player visit gift house' do

      before(:each) do
        @gift_house = GiftHouse.new 0
        allow(@map).to receive(:place_at).with(1) { @gift_house }

        @player.execute @command

        expect(@player.location).to eq(1)
        expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
      end

      it 'should gain money then turn end when player respond 1' do
        @player.respond 1

        expect(@player.money).to eq(INITIAL_BALANCE + 2000)
      end

      it 'should gain money then turn end when player respond 1' do
        @player.respond 2

        expect(@player.point).to eq(INITIAL_POINT + 200)
      end

      it 'should gain money then turn end when player respond 1' do
        @player.respond 3

        expect(@player.has_evisu?).to eq(5)
      end

      after(:each) do
        expect(@player.status).to eq(Player::Status::TURN_END)
      end

    end
  end

end