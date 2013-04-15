class ComputerPlayer
  attr_accessor :minimax, :char

  def initialize(char, minimax = Minimax)
    self.minimax = minimax
    self.char = char
  end

  def get_next_move(board)
    minimax_result = self.minimax.run(board)
    (0..8).each do |i|
      minimax_result[i] -= 2 if minimax_result[i] == 0
    end

    best_move_from minimax_result
  end

  private
  def best_move_from(scores)
    scores.each_with_index.max[1].to_s
  end
end
