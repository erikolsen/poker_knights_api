class Hand < ApplicationRecord
  belongs_to :game
  has_many :rounds

  STARTING_POSITION = [ [[7,0], [7,7], [0,0], [0,7]] ]
  serialize :position
  serialize :cards
  serialize :white
  serialize :black

  def reset!
    update({position: STARTING_POSITION})
  end

  def add_move(pos, move)
    new_position = position.last.each_with_index.map{ |current,idx| idx == pos ? move : current }
    position << new_position
  end
end

