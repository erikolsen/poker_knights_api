module Games
  module Hands
    class RoundsController < ApplicationController
      def show
        render json: {white: hand.white,
                      black: hand.black,
                      knights: hand.position.last,
                      cards: hand.cards,
                      pot: round.pot,
                      bets: round.bets || []
                     }.merge(game.as_json)
      end

      def fold
        player = Player.find_by(name: params[:player])
        winner = game.opponent_of(player)
        winner.stack += round.pot

        if winner.save
          game.deal!
          HandsChannel.broadcast_to game, {newHandSeq: game.hands.last.sequence}
          render json: {success: true }
        else
          render json: {failure: true }
        end
      end

      def winner
        color = params[:winner]
        winner = color == 'white' ? game.player_one : game.player_two
        winner.stack += round.pot

        if winner.save
          RoundsChannel.broadcast_to round,
            { showWinner: true,
              bets: round.bets,
              betting: false,
              showBetBar: false,
              pot: 0,
              playerOneStack: game.player_one.stack,
              playerTwoStack: game.player_two.stack}
          render json: {success: true }
        else
          render json: {failure: true }
        end
      end

      def call
        player = params[:game][:player]
        bet = params[:game][:bet]
        round.add_bet(player, bet)
        if round.save
          RoundsChannel.broadcast_to round,
            { showWinner: true,
              bets: round.bets,
              betting: false,
              showBetBar: false,
              pot: round.pot,
              playerOneStack: game.player_one.stack,
              playerTwoStack: game.player_two.stack}
          render json: {success: true }
        else
          render json: {failure: true }
        end
      end

      def bet
        player = params[:game][:player]
        bet = params[:game][:bet]
        round.add_bet(player, bet)
        #player = round.entrant_for(player)
        if round.save
          RoundsChannel.broadcast_to round, {bets: round.bets, pot: round.pot, playerOneStack: game.player_one.stack, playerTwoStack: game.player_two.stack, betting: true, showBetBar: true}
          render json: {success: true }
        else
          render json: {failure: true }
        end
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
        #@round ||= hand.rounds.where(sequence: params[:id]).first ||
        @round ||= hand.rounds.first
      end

    end
  end
end
