class RoundsChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find_by(slug: params[:gameId])
    hand = game.hands.where(sequence: params[:handId]).first
    #round = hand.rounds.where(sequence: params[:roundId]).first
    round = hand.rounds.first
    stream_for round
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
