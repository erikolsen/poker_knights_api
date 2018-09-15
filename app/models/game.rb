class Game < ApplicationRecord
  serialize :position
  serialize :white
  serialize :black
end
