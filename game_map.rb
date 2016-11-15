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
    # todo
  end

  def player_at(position)
    @players.select { |player| player.location.equal? position }.first
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
end