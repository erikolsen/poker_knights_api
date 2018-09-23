class LobbysChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
     game = Game.find_by(slug: params[:gameId])
      puts '*' * 80
      puts 'In lobby'
      puts game.as_json
      puts '*' * 80

     stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
