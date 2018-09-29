class Round < ApplicationRecord
  belongs_to :hand
  serialize :bets, Array

  def entrant_for(name)
    player = Player.find_by(name: name)
    hand.game.entrants.where(player_id: player.id).first
  end

  def add_bet(player, bet)
    entrant = entrant_for(player)
    entrant.update(stack: entrant.stack - bet.to_i)
    entrant.save!
    update(pot: pot + bet.to_i)
    bets << [{player: player, bet: bet}]
    save!
  end
end
