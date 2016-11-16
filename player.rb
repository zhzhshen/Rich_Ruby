
class Player
  attr_accessor :status, :position, :map, :money, :point, :items, :name, :color

  def initialize(map, money, point, name = '', legend = '', color = '')
    @map = map
    @position = 0
    @money = money
    @special_status = Hash.new
    @items = [BOMB, BLOCK, ROBOT]
    @point = point
    @name = name
    @legend = legend
    @color = color
    @status = Status::TURN_END
  end

  def print_map
    print @color + @legend + Color::ANSI_RESET
  end

  def start_turn
    if in_hospital?
      @status = Status::TURN_END
      @special_status[:IN_HOSPITAL] -= 1
      if in_hospital?.equal? 0
        @special_status.delete :IN_HOSPITAL
      end
    elsif in_prison?
      @status = Status::TURN_END
      @special_status[:IN_PRISON] -= 1
      if in_prison?.equal? 0
        @special_status.delete :IN_PRISON
      end
    else
      @status = Status::WAIT_FOR_COMMAND
    end
  end

  def execute(command)
    @command = command
    @command.execute self
  end

  def respond(response)
    @command.respond self, response
  end

  def visit
    @map.place_at(@position).visit_by self
  end

  def reduce_money(amount)
    @money -= amount unless @money < amount
  end

  def gain_money(amount)
    @money += amount
  end

  def reduce_point(amount)
    @point -= amount unless @point < amount
  end

  def gain_point(amount)
    @point += amount
  end

  def burn
    @special_status[:IN_HOSPITAL] = 3
    @position = @map.get_hospital_location
  end

  def in_hospital?
    @special_status[:IN_HOSPITAL]
  end

  def prisoned
    @special_status[:IN_PRISON] = 2
  end

  def in_prison?
    @special_status[:IN_PRISON]
  end

  def evisu
    @special_status[:HAS_EVISU] = 5
  end

  def has_evisu?
    @special_status[:HAS_EVISU]
  end

  module Status
    WAIT_FOR_COMMAND = 'WAIT_FOR_COMMAND'
    WAIT_FOR_RESPONSE = 'WAIT_FOR_RESPONSE'
    TURN_END = 'TURN_END'
    BROKEN = 'BROKEN'
  end

  module Color
    ANSI_RESET = "\u001B[0m"
    ANSI_RED = "\u001B[31m"
    ANSI_GREEN = "\u001B[32m"
    ANSI_YELLOW = "\u001B[33m"
    ANSI_BLUE = "\u001B[34m"
  end

end