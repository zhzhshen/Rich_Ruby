
class Player
  attr_accessor :status

  def startTurn
    @status = Status::WAIT_FOR_COMMAND
  end

  def execute(command)
    @command = command
    @command.execute self
  end

  def respond(response)
    @command.respond self, response
  end

  module Status
    WAIT_FOR_COMMAND = 'WAIT_FOR_COMMAND'
    WAIT_FOR_RESPONSE = 'WAIT_FOR_RESPONSE'
    TURN_END = 'TURN_END'
  end

end