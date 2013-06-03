class ComputerPlayer
  attr_accessor :minimax

  def initialize(minimax = Minimax)
    self.minimax = minimax
  end

  def get_next_move(board)
    minimax_result = self.minimax.run(board)

    best_move_from minimax_result
  end

  private
  def best_move_from(scores)
    scores.each_with_index.max[1].to_s
  end
end
