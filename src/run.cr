require "./game.cr"
require "./human_player.cr"
require "./q_learning_player.cr"

p = QL::HumanPlayer.new
g = QL::Game.new(p)
g.run
