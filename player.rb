
class Player
  attr_accessor :status, :location, :map, :money

  def initialize(map, money)
    @map = map
    @location = 0
    @money = money
  end

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

  def visit
    @map.place_at(@location).visit_by self
  end

  def reduce_money(amount)
    @money -= amount unless @money < amount
  end

  module Status
    WAIT_FOR_COMMAND = 'WAIT_FOR_COMMAND'
    WAIT_FOR_RESPONSE = 'WAIT_FOR_RESPONSE'
    TURN_END = 'TURN_END'
  end

end