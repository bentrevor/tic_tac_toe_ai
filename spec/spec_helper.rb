def place_many(x_positions, o_positions)
  while x_positions.length > 0
    board.place x_positions.shift
    board.place o_positions.shift unless o_positions.length == 0
  end
end

