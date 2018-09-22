class MovesChannel < ApplicationCable::Channel
  def subscribed
     puts 'maybe doing something'
     game = Game.find_by(slug: params[:gameId])
     hand = game.hands.where(sequence: params[:handId]).first
     stream_for hand
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
