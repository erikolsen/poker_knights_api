module Games
  class HandsController < ActionController::API
    #def show
      #puts params
      #game = Game.find_by(slug: params[:id]) || GameCreator.new.game

      #cards = game.cards
      #knights = game.position.last
      #white = game.white
      #black = game.black

      #render json: {white: {hand: white},
                    #black: {hand: black},
                    #knights: knights,
                    #cards: cards }
    #end

    #def move
      #game = Game.find(params[:game_id])
      #position = params[:game][:position]
      #move = params[:game][:move]
      #game.add_move(position, move)
      #if game.save
        #MovesChannel.broadcast_to game, {move: game.position.last}
        #render json: {success: true }
      #else
        #render json: {failure: true }
      #end
    #end

  #end
end
