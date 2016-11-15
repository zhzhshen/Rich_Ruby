
class Player
  attr_accessor :status, :location, :map, :money

  def initialize(map, money)
    @map = map
    @location = 0
    @money = money
    @special_status = Hash.new
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

  def gain_money(amount)
    @money += amount
  end

  def burn
    @special_status[:IN_HOSPITAL] = 3
  end

  def in_hospital?
    !!@special_status[:IN_HOSPITAL]
  end

  def prisoned
    @special_status[:IN_PRISON] = 2
  end

  def in_prison?
    !!@special_status[:IN_PRISON]
  end

  def evisu
    @special_status[:HAS_EVISU] = 5
  end

  def has_evisu?
    !!@special_status[:HAS_EVISU]
  end

  module Status
    WAIT_FOR_COMMAND = 'WAIT_FOR_COMMAND'
    WAIT_FOR_RESPONSE = 'WAIT_FOR_RESPONSE'
    TURN_END = 'TURN_END'
    BROKEN = 'BROKEN'
  end

end