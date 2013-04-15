require_relative '../lib/tic_tac_toe_ai/computer_player.rb'
require_relative '../lib/tic_tac_toe_ai/board.rb'

describe ComputerPlayer, '#get_next_move' do
  let(:fake_minimax) { mock }
  let(:computer_player) { ComputerPlayer.new 'x', fake_minimax }
  let(:board) { Board.new }

  it "should return the index of the largest element" do
    fake_minimax_result = Array.new([1,2,3,4,5,6,7,8,9])
    computer_player.minimax.should_receive(:run).and_return fake_minimax_result
    computer_player.get_next_move(board).should eq "8"
  end
end
