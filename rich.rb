#!/usr/bin/ruby
require './game_map'
require './game'
require './player'

if __FILE__ == $0
  puts 'Welcome to Rich World!'

  @balance = 10000

  loop do
    puts '请选择玩家初始资金 范围1000～50000（默认10000)'
    input_string = gets
    if input_string == "\n"
      break
    end
    @balance = input_string.chomp.to_i

    break if (@balance >= 1000 && @balance <= 50000)
  end

  @map = GameMap.new
  @map.init

  loop do
    @players = Array.new
    puts '请选择2~4位不重复玩家，输入编号即可。(1.钱夫人; 2.阿土伯; 3.小丹尼; 4.金贝贝):'
    player_indexs = gets.chomp.split ''

    valid = true
    player_indexs.each { |x|
      case x.to_i
        when 1
          name = '钱夫人'
          legend = 'Q'
          color = 'r'
        when 2
          name = '阿土伯'
          legend = 'A'
          color = 'y'
        when 3
          name = '小丹尼'
          legend = 'X'
          color = 'b'
        when 4
          name = '金贝贝'
          legend = 'J'
          color = 'g'
        else
          valid &= false
      end
      @players.push Player.new @map, @balance, 200, name, legend, color
    }
    break if valid
  end

  @game = Game.new(@map, *@players)

  @map.print_map

  while
    @game.start_turn
    while (!game.getActivePlayer().getStatus().equals(Player.Status.TURN_END))
      @map.print_map
    end
    @game.end_turn
  end

end