class Minimax
  def self.run(board, depth = 0)
    scores = Array.new(9, 0)

    board.available_positions.each do |position|
      board.place position
      scores[position] = assign_score_to_board(board, depth)
      board.spaces[position] = nil
    end

    scores
  end

  def self.assign_score_to_board(board, depth)
    if board.check_winner? board.other_char
      9 - depth
    elsif board.empty_spaces == 0
      0.5
    else
      scores = run(board, depth + 1)
      return 0.5 if scores.max == 0.5
      -1 * scores.max
    end
  end
end
