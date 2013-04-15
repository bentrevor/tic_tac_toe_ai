require_relative 'spec_helper.rb'
require_relative '../lib/tic_tac_toe_ai/board.rb'

describe Board do
  let(:board) { Board.new }
  let(:player_1) { mock(char: 'x') }
  let(:player_2) { mock(char: 'o') }
  let(:fake_game) { mock.as_null_object }

  before :each do
    board.add_observer fake_game
  end

  context 'observers' do
    describe '#add_observer' do
      it "should add an observer to board.observers" do
        expect {board.add_observer(fake_game)}.to change{board.observers.length}.by 1
      end
    end

    describe '#notify_observers' do
      it "should send a message to each observer" do
        board.observers = [fake_game, mock, mock]
        assert_notification :continue
        board.update_state
      end

      it "only sends the board when the notification is :game_over" do
        fake_game.should_receive(:continue).with()
        place_many [0,1], [3,4]
        board.update_state

        fake_game.should_receive(:game_over).with(board)
        board.place 2
        board.update_state
      end
    end
  end

  context 'state' do
    describe '#state_allows_move?' do
      it "should return true for a valid move" do
        board.state_allows_move?('x', 0).should be true
      end

      it "should return false for a non-available square" do
        board = Board.new ['x',nil,nil,nil,nil,nil,nil,nil,nil]
        board.state_allows_move?('o', 0).should be false
      end

      it "should return false for positions > 8" do
        board.state_allows_move?('x', 9).should be false
      end

      it "should return false for positions < 0" do
        board.state_allows_move?('x', -1).should be false
      end
    end
  end

  describe 'notifications' do
    it "sends the board with :game_over" do
      place_many [0,1,2], [3,4]
      board.observers[0].should_receive(:game_over).with(board)
      board.update_state
    end

    it "should send :game_over when 'x' wins" do
      place_many [0,1,2], [3,4]
      assert_notification :game_over
      board.update_state
    end

    it "should send :game_over when 'o' wins" do
      place_many [0,1,7], [3,4,5]
      assert_notification :game_over
      board.update_state
    end

    it "should send :game_over when the board is full" do
      place_many [0,2,3,7,8], [1,4,5,6]
      assert_notification :game_over
      board.update_state
    end
  end

  describe '#try_move' do
    it "should send a notification to restart" do
      assert_notification :restart
      board.try_move 'x', 'restart'
    end

    context 'valid move' do
      it "should place an 'x'" do
        assert_try_move_success 'x', "0"
      end

      it "should place an 'o'" do
        board.try_move 'x', "0"
        assert_try_move_success 'o', "1"
      end
    end

    context 'invalid move' do
      it "should not place a character in an unavailable position" do
        board.try_move(player_1.char, 0)
        board.try_move(player_2.char, 1)
        assert_try_move_failure 'x', 1
        board.spaces[1].should_not eq player_1.char
      end

      it "should not place an 'x' if it isn't player 1's turn" do
        board.try_move(player_1.char, 0)
        assert_try_move_failure 'x', 1
      end

      it "should not place an 'o' if it isn't player 2's turn" do
        assert_try_move_failure 'o', 0
      end

      it "should send a message for unavailable positions" do
        assert_notification :unavailable_position
        board.try_move 'x', "0"
        board.try_move 'o', "0"
      end

      it "should send a message for an invalid index" do
        assert_notification :invalid_position
        board.try_move 'x', "-1"
      end

      it "should send a message for an invalid index" do
        assert_notification :invalid_position
        board.try_move 'x', "9"
      end

      it "should send a message for incorrect players" do
        assert_notification :incorrect_player
        board.try_move 'x', "0"
        board.try_move 'x', "1"
      end

      it 'should send a message for "\n"' do
        assert_notification :invalid_position
        board.try_move 'x', ""
      end

      it "should send a message for a string other than 'restart'" do
        assert_notification :invalid_position
        board.try_move 'x', "hey"
      end
    end
  end

  describe '#empty_spaces' do
    it "should be able to count the empty spaces" do
      board.empty_spaces.should be 9
      board.place 1
      board.place 2
      board.empty_spaces.should be 7
      board.place 3
      board.place 4
      board.empty_spaces.should be 5
    end
  end

  describe '#available?' do
    it "should start as true for all spaces" do
      (0..8).each do |position|
        board.available?(position).should be true
      end
    end

    it "should be false when space is taken" do
      board.place 2
      board.place 5
      board.available?(2).should be false
      board.available?(5).should be false
    end
  end

  describe '#game_over?' do
    it "should be false at the beginning of the game" do
      board.game_over?.should be false
    end

    it "should be true when the board is full" do
      place_many [0,2,3,7,8], [1,4,5,6]
      board.game_over?.should be true
    end

    it "should be true when 'x' has three in a row" do
      board = Board.new(['x', 'x', 'x',
                         nil, nil, nil,
                         nil, nil, nil])
      board.game_over?.should be true
      board = Board.new([nil, nil, 'x',
                         nil, 'x', nil,
                         'x', nil, nil])
      board.game_over?.should be true
      board = Board.new(['x', nil, nil,
                         'x', nil, nil,
                         'x', nil, nil])
      board.game_over?.should be true
      board = Board.new([nil, 'x', nil,
                         nil, 'x', nil,
                         nil, 'x', nil])
      board.game_over?.should be true
    end

    it "should be true when 'o' has three in a row" do
      board = Board.new(['o', 'o', 'o',
                         nil, nil, nil,
                         nil, nil, nil])
      board.game_over?.should be true
      board = Board.new([nil, nil, 'o',
                         nil, 'o', nil,
                         'o', nil, nil])
      board.game_over?.should be true
      board = Board.new(['o', nil, nil,
                         'o', nil, nil,
                         'o', nil, nil])
      board.game_over?.should be true
      board = Board.new([nil, 'o', nil,
                         nil, 'o', nil,
                         nil, 'o', nil])
      board.game_over?.should be true
    end
  end

  describe '#check_winner?' do
    it "should be false when the board is empty" do
      board.check_winner?('x').should be false
      board.check_winner?('o').should be false
    end

    it "should be true when x has three in a row" do
      place_many [0,1,2], [7,8]
      board.check_winner?('x').should be true
    end

    it "should be true when o has three in a row" do
      place_many [7,8,4], [0,1,2]
      board.check_winner?('o').should be true
    end
  end

  describe '#available_positions' do
    it "should be an empty array for a full board" do
      place_many [0,2,3,7,8], [1,4,5,6]
      board.available_positions.should eq []
    end

    it "should return (0..8) for an empty board" do
      board.available_positions.should eq [0,1,2,3,4,5,6,7,8]
    end
  end

  describe '#current_char' do
    it "should be 'x' for an empty board" do
      board.current_char.should eq 'x'
    end

    it "should be 'o' after an x has been placed" do
      board.place 1
      board.current_char.should eq 'o'
    end
  end

  describe '#other_char' do
    it "should be 'o' for an empty board" do
      board.other_char.should eq 'o'
    end

    it "should be 'x' after an x has been placed" do
      board.place 1
      board.other_char.should eq 'x'
    end
  end

  def clear_board
    board.spaces = Array.new 9
  end
 
  def assert_try_move_success(player_char, position)
    board.try_move(player_char, position)
    board.spaces[position.to_i].should eq player_char
  end

  def assert_try_move_failure(player_char, position)
    board.try_move(player_char, position)
    board.spaces[position].should_not eq player_char
  end

  def assert_notification(notification)
    board.observers.each do |observer|
      observer.should_receive notification
    end
  end
end
