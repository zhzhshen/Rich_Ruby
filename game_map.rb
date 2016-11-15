class GameMap

  attr_accessor :players

  def initialize(*place)
    @items = Hash.new
    @places = place
    @players = Array.new
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
    @players.select { |player| player.location.equal? position }.first
  end

  def move(player, step)
    target = self.move_step_forward player.location, step
    item = @items.select {|pos, item| self.in_between(pos, player.location, target)}.first
    if !item.nil?
      @items.delete item
      item[1].new.trigger(player, item[0])
    else
      player.location = target
    end

  end

  def move_step_forward(start, step)
    target = start + step
    target > @places.size ? target % @places.size : target
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