module Games
  module Hands
    class RoundsController < ApplicationController
      def show
        cards = hand.cards
        knights = hand.position.last
        white = hand.white
        black = hand.black

        render json: {white: white,
                      black: black,
                      knights: knights,
                      cards: cards }
      end

      def move
        position = params[:game][:position]
        move = params[:game][:move]
        hand.add_move(position, move)
        if hand.save
          MovesChannel.broadcast_to hand, {move: hand.position.last}
          render json: {success: true }
        else
          render json: {failure: true }
        end
      end

      def game
        @game ||= Game.find_by(slug: params[:game_id])
      end

      def hand
        @hand ||= game.hands.where(game_id: game.id, sequence: params[:hand_id]).first
      end

      def round
        @round ||= hand.rounds.where(sequence: params[:id]).first
      end

    end
  end
end
