class MovesChannel < ApplicationCable::Channel
  def subscribed
     puts 'maybe doing something'
     game = Game.find(params[:games])
     raise 'No Game' unless game
     stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
