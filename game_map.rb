require './starting_point'
require './estate'
require './hospital'
require './tool_house'
require './gift_house'
require './magic_house'
require './mine'
require './police'
class GameMap

  attr_accessor :players

  def initialize(*place)
    @items = Hash.new
    @places = place
    @players = Array.new
  end

  def init
    @places.clear
    @places.push StartingPoint.new 0
    (1..13).each {|x| @places.push Estate.new x, 200}
    @places.push Hospital.new 14
    (15..27).each {|x| @places.push Estate.new x, 200}
    @places.push ToolHouse.new 28
    (29..34).each {|x| @places.push Estate.new x, 500}
    @places.push GiftHouse.new 35
    (36..48).each {|x| @places.push Estate.new x, 300}
    @places.push Police.new 49
    (50..62).each {|x| @places.push Estate.new x, 300}
    @places.push MagicHouse.new 63
    @places.push Mine.new 64, 20
    @places.push Mine.new 65, 80
    @places.push Mine.new 66, 100
    @places.push Mine.new 67, 40
    @places.push Mine.new 69, 60
    @places.push Mine.new 68, 80
  end

  def print_map
    (0..28).each {|x|
      self.print_at x
    }
    puts

    69.downto(64).each { |x|
      self.print_at x
      print ' ' * 27
      self.print_at (98 - x)
      puts
    }

    (35..63).each {|x|
      self.print_at (98 - x)
    }
    puts
  end

  def print_at(pos)
    if !!item_at(pos)
      item_at(pos).print_map
    elsif !!player_at(pos)
      player_at(pos).print_map
    else
      place_at(pos).print_map
    end
  end

  def put_item(item, position)
    @items[position] = item
  end

  def item_at(position)
    @items[position]
  end

  def place_at(position)
    @places.select { |place| place.position.equal? position}.first
  end

  def player_at(position)
    @players.select { |player| player.position.equal? position }.first
  end

  def move(player, step)
    target = self.move_step_forward player.position, step
    item = @items.select {|pos, item| self.in_between(pos, player.position, target)}.first
    if !item.nil?
      @items.delete item[0]
      item[1].trigger(player, item[0])
    else
      player.position = target
    end

  end

  def move_step_forward(start, step)
    target = start + step
    target >= @places.size ? target % @places.size : target
  end

  def clear_items(start, step)
    target = self.move_step_forward start, step
    @items = @items.select {|pos, item| self.in_between(pos, start, target)}
  end

  def in_between(index, start, target)
    (start <= index && index <= target ) || (index <= target && target <= start) || (target <= start && start <= index)
  end

  def get_hospital_location
    @places.select {|place| place.instance_of?Hospital}.map{|place|place.position}.first
  end
end