require_relative './command'

class BombCommand < Command

  attr_accessor :steps

  def initialize(steps)
    @steps = steps
  end

  def execute(player)
    target_position = player.map.move_step_forward player.position, @steps
    if player.items.any? { |item| item.equal? BOMB } && @steps.abs<=10 && player.map.item_at(target_position).nil? && player.map.player_at(target_position).nil?
      player.items.delete BOMB
      player.map.put_item(BOMB, target_position)
      '使用炸弹成功'
    end
  end

end