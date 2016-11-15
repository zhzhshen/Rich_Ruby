require './command'
class SellToolCommand < Command
  def initialize(itemIndex)
    @itemIndex = itemIndex
  end

  def execute(player)
    case @itemIndex
      when 1
        if player.items.any? { |item| item.equal? BLOCK }
          player.items.delete BLOCK
          player.gain_point BLOCK_POINT
        end
      when 2
        if player.items.any? { |item| item.equal? ROBOT }
          player.items.delete ROBOT
          player.gain_point ROBOT_POINT
        end
      when 3
        if player.items.any? { |item| item.equal? BOMB }
          player.items.delete BOMB
          player.gain_point BOMB_POINT
        end
    end

  end
end