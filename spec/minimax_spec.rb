require_relative '../lib/tic_tac_toe_ai/minimax'
require_relative '../lib/tic_tac_toe_ai/board'

describe Minimax do
  let(:board) { Board.new ['x','o','x',
                           'o','o','x',
                           nil,nil,nil]
              }

  it "assigns a positive score to a winning board" do
    board.place 8
    Minimax.assign_score_to_board(board, 1).should be > 0
  end

  it "assigns a negative score to a board that's going to lose" do
    board.place 6
    Minimax.assign_score_to_board(board, 1).should be < 0
  end

  it "assigns a negative score to a board that's going to lose" do
    board.place 7
    board.place 6
    Minimax.assign_score_to_board(board, 1).should be < 0
  end

  it "assigns 0.5 to a board that is tied" do
    board.place 7
    board.place 8
    board.place 6
    Minimax.assign_score_to_board(board, 1).should be 0.5
  end

  it "assigns 0.5 to a board that will be tied" do
    board.place 7
    board.place 8
    Minimax.assign_score_to_board(board, 1).should be 0.5
  end

  it "assigns a positive score to a winning move" do
    Minimax.run(board)[8].should be > 0
  end

  it "assigns a negative score to a losing move" do
    Minimax.run(board)[6].should be < 0
  end

  it "assigns 0.5 to a tying move" do
    Minimax.run(board)[7].should be 0.5
  end

  context 'using different board' do
    it "assigns a better score to a faster win" do
      board = Board.new ['x','o','o',
                         nil,nil,nil,
                         'x',nil,nil]
      score_for_3 = Minimax.run(board)[3]
      score_for_7 = Minimax.run(board)[7]
      score_for_3.should be > score_for_7
    end

    it "assigns a positive score to a winning board" do
      board = Board.new ['x','o',nil,
                         nil,nil,nil,
                         'x',nil,nil]
      Minimax.assign_score_to_board(board, 1).should be > 0
    end

    it "assigns a negative score to a winning board" do
      board = Board.new ['x','o',nil,
                         nil,nil,nil,
                         'x',nil,'o']
      Minimax.assign_score_to_board(board, 1).should be < 0
    end

    it "is positive for a winning board" do
      board = Board.new ['x','o','x',
                         nil,'o','x',
                         nil,'o',nil]
      Minimax.assign_score_to_board(board, 1).should be > 0
    end
  end
end
