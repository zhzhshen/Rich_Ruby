require './command'

class BlockCommand < Command

  attr_accessor :steps

  def initialize(steps)
    @steps = steps
  end

  def execute(player)
    target_position = player.map.move_step_forward player.position, @steps
    if player.items.any? { |item| item.equal? BLOCK } && @steps.abs<=10 && player.map.item_at(target_position).nil? && player.map.player_at(target_position).nil?
      player.items.delete BLOCK
      player.map.put_item(BLOCK, target_position)
    end
  end
end