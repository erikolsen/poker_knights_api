class Game < ApplicationRecord
  serialize :position
  serialize :cards
  serialize :white
  serialize :black

  def reset!
    update({position: [ [[7,0], [7,7], [0,0], [0,7]] ]})
  end

  def add_move(pos, move)
    new_position = position.last.each_with_index.map{ |current,idx| idx == pos ? move : current }
    puts new_position
    position << new_position
  end
end
