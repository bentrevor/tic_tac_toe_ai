require "tic_tac_toe_ai/version"
require "tic_tac_toe_ai/board"
require "tic_tac_toe_ai/computer_player"
require "tic_tac_toe_ai/minimax"

module TicTacToeAi
  def self.create_board
    Board.new
  end
end
