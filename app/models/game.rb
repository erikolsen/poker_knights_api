module Deck
  def self.shuffle!
    #suits = ['s', 'h', 'd', 'c']
    suits = ['♠', '♥', '♦', '♣']
    num = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.map{|suit| num.map{|rank| rank + suit }}.flatten.shuffle
  end
end

class Game < ApplicationRecord
  has_many :hands, -> { order(:sequence) }
  has_many :entrants, -> { order(:sequence) }
  has_many :players, through: :entrants
  validates :slug, uniqueness: true

  def add_player(player_name, seq)
    player = Player.find_or_create_by(name: player_name)
    if !players.include? player && players.count <= 2
      entrants << Entrant.create(player: player, sequence: seq, ready: true)
    end
  end

  def player_one
    entrants[0] if entrants.count <= 2 && entrants.count > 0
  end

  def player_two
    entrants[1] if entrants.count == 2
  end

  def as_json
    super.merge(playerOne: player_one&.player&.name || '',
                playerOneReady: player_one&.ready || false,
                playerTwo: player_two&.player&.name || '',
                playerTwoReady: player_two&.ready || false)
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

