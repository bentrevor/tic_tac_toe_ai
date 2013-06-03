class Board
  attr_accessor :spaces, :winning_combos, :observers

  def initialize(initial_board = Array.new(9))
    self.spaces = initial_board
    self.winning_combos = [ [0,1,2],
                            [3,4,5],
                            [6,7,8],
                            [0,3,6],
                            [1,4,7],
                            [2,5,8],
                            [0,4,8],
                            [2,4,6] ]
    self.observers = Array.new
  end

  def add_observer(observer)
    self.observers << observer
  end

  def notify_observers(notification)
    self.observers.each do |observer|
      observer.send notification
    end
  end

  def update_state
    if game_over?
      notify_game_over
    else
      notify_observers :continue
    end
  end

  def place(position)
    self.spaces[position] = self.current_char
  end

  def try_move(player_char, position)
    if !game_over?
      check_invalid_inputs position

      if state_allows_move? player_char, position.to_i
        place position.to_i
        update_state
      end
    end
  end

  def state_allows_move?(player_char, position)
    if !available? position
      notify_observers :unavailable_position
      return false
    elsif out_of_range? position
      notify_observers :invalid_position
      return false
    elsif wrong_player? player_char
      notify_observers :incorrect_player
      return false
    end

    true
  end

  def empty_spaces
    (0..8).count { |position| available? position }
  end

  def available?(position)
    spaces[position].nil?
  end
  
  def game_over?
    empty_spaces == 0 || check_winner?('x') || check_winner?('o')
  end

  def check_winner?(char)
    (0..7).each do |combo_index|
      return true if (self.spaces[self.winning_combos[combo_index][0]] == char and self.spaces[self.winning_combos[combo_index][1]] == char and self.spaces[self.winning_combos[combo_index][2]] == char)
    end
    false
  end

  def available_positions
    (0..8).find_all { |position| available? position }
  end

  def current_char
    empty_spaces.odd? ? 'x' : 'o'
  end

  def other_char
    empty_spaces.odd? ? 'o' : 'x'
  end

  private
  def restart?(position)
    position == "restart"
  end

  def blank?(position)
    position == ""
  end

  def not_number?(position)
    position.to_i.to_s != position
  end

  def check_invalid_inputs(position)
    if restart? position
      notify_observers :restart
    elsif blank?(position) or not_number?(position)
      notify_observers :invalid_position
    end
  end

  def out_of_range?(position)
    position > 8 or position < 0
  end

  def wrong_player?(char)
    current_char != char
  end

  def notify_game_over
    if check_winner? 'x'
      notify_observers :x_wins
    elsif check_winner? 'o'
      notify_observers :o_wins
    else
      notify_observers :tie_game
    end
  end
end
