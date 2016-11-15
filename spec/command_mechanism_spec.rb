require 'rspec'
require_relative '../player'
require_relative '../command'

describe Player do

  describe ('#execute') do

    before(:each) do
      @player = Player.new
      @player.startTurn
      @command = double
      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)

      expect(@command).to receive(:execute).with(@player)
    end

    it 'should wait for command when execute responsiveness command' do
      allow(@command).to receive(:execute).with(@player) {@player.status = Player::Status::WAIT_FOR_COMMAND}

      @player.execute @command

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end

    it 'should turn end when execute responsiveness command' do
      allow(@command).to receive(:execute).with(@player) {@player.status = Player::Status::TURN_END}

      @player.execute @command

      expect(@player.status).to eq(Player::Status::TURN_END)
    end

    it 'should wait for response when execute responsive command' do
      allow(@command).to receive(:execute).with(@player) {@player.status = Player::Status::WAIT_FOR_RESPONSE}

      @player.execute @command

      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)
    end

    it 'should turn end when player respond to responsive command' do
      allow(@command).to receive(:execute).with(@player) {@player.status = Player::Status::WAIT_FOR_RESPONSE}

      @player.execute @command

      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)

      response = double
      expect(@command).to receive(:respond).with(@player, response)
      allow(@command).to receive(:respond).with(@player, response) {@player.status = Player::Status::TURN_END}

      @player.respond response

      expect(@player.status).to eq(Player::Status::TURN_END)
    end

    it 'should wait for command when player respond to responsive command' do
      allow(@command).to receive(:execute).with(@player) {@player.status = Player::Status::WAIT_FOR_RESPONSE}

      @player.execute @command

      expect(@player.status).to eq(Player::Status::WAIT_FOR_RESPONSE)

      response = double
      expect(@command).to receive(:respond).with(@player, response)
      allow(@command).to receive(:respond).with(@player, response) {@player.status = Player::Status::WAIT_FOR_COMMAND}

      @player.respond response

      expect(@player.status).to eq(Player::Status::WAIT_FOR_COMMAND)
    end
  end
end