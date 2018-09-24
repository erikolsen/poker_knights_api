module Deck
  def self.shuffle!
    suits = ['♠', '♥', '♦', '♣']
    num = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.map{|suit| num.map{|rank| rank + suit }}.flatten.shuffle
  end
end

class Game < ApplicationRecord
  has_many :hands
  has_many :entrants, -> { order(:sequence) }
  has_many :players, through: :entrants

  def add_player(player_name, seq)
    player = Player.find_or_create_by(name: player_name)
    entrants << Entrant.create(player: player, sequence: seq)
  end

  def deal!
    begin
      cards = Deck.shuffle!
      white = cards.pop(2)
      black = cards.pop(2)
      hand = Hand.create(cards: cards.take(24),
                         sequence: hands.count + 1,
                         game_id: id,
                         position: Hand::STARTING_POSITION,
                         white: white,
                         black: black)
      3.times { |round| hand.rounds << Round.create(sequence: round + 1, pot: 0) }
      return true
    rescue => e
      raise e
    end
  end

end

