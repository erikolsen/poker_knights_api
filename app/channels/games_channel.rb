class GamesChannel < ApplicationCable::Channel
  def subscribed
      puts '*' * 80
      puts 'In games channel'
      puts '*' * 80
     stream_from "games_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
