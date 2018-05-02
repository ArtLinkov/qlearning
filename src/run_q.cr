require "./game.cr"
require "./human_player.cr"
require "./q_learning_player.cr"

p = QL::QLPlayer.new(lr = 0.6, dc = 0.8, eps = 0.85)
g = QL::Game.new(p)
p.game_init(g)

# puts "Start the game? (press any key)"
# gets

100.times do
  g.run
  g.new_run
  if g.quit == true
    break
  end
end

puts "--------------------------------------"
puts "Q-table (Key = state, Value = actions for that state):"
p.qtable.each { |row| puts row }
# puts "Continue? (press any key)"
# gets

puts "#######################################"
