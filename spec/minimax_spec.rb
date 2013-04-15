# require 'spec_helper'
require_relative '../lib/tic_tac_toe_ai/minimax.rb'
# require 'board'
# require 'console_io'

describe Minimax do
  let(:board) { Board.new }

  describe '#run' do
    before :each do
      first_six_moves
    end

    it "should assign a positive score to a winning move" do
      Minimax.run(board)[8].should be > 0
    end

    it "should assign a negative score to a losing move" do
      Minimax.run(board)[6].should be < 0
    end

    it "should be 0.5 for tying move" do
      Minimax.run(board)[7].should == 0.5
    end
  end

  describe '#assign_score_to_board' do
    context 'accounting for depth' do
      it "should assign a better score to a faster win" do
        place_many [0,6], [1,2]
        score_for_3 = Minimax.run(board)[3]
        score_for_7 = Minimax.run(board)[7]
        score_for_3.should be > score_for_7
      end
    end

    it "should be positive for a winning position" do
      place_many [0,6], [1]
      Minimax.assign_score_to_board(board, 1).should be > 0
    end

    it "should be negative for a losing position" do
      place_many [0,6], [1,8]
      Minimax.assign_score_to_board(board, 1).should be < 0
    end

    context 'using first_six_moves' do
      before :each do
        first_six_moves
      end

      it "should be positive for a move that wins" do
        board.place 8
        Minimax.assign_score_to_board(board, 1).should be > 0
      end

      it "should be negative for a move that loses" do
        board.place 6
        Minimax.assign_score_to_board(board, 1).should be < 0
      end

      it "should be negative for a move that loses" do
        board.place 7
        board.place 6
        Minimax.assign_score_to_board(board, 1).should be < 0
      end

      it "should be .5 for a move that ties" do
        board.place 7
        Minimax.assign_score_to_board(board, 1).should eq 0.5
      end

      it "should be .5 for a move that ties" do
        board.place 7
        board.place 8
        Minimax.assign_score_to_board(board, 1).should eq 0.5
      end
    end
  end

  it "should be positive for a move that wins" do
    place_many [0,2,5], [1,4,7]
    Minimax.assign_score_to_board(board, 1).should be > 0
  end

  def debug(board)
    puts "============="
    ConsoleIO.show board
    pp Minimax.run board
    puts "============="
  end

  def first_six_moves
    place_many [0,2,5], [1,3,4]
  end
end
