class GameCreator
  attr_reader :slug, :stack, :big_blind, :small_blind, :timer, :player_one, :player_two, :game

  def initialize(params)
    @slug = params[:gameId]
    @stack = params[:stack].to_i
    @big_blind = params[:blinds].to_i
    @small_blind = params[:blinds].to_f / 2
    @timer = params[:timer].to_i
    @player_one = params[:playerOne]
    @player_two = params[:playerTwo]
  end

  def setup_game!
    begin
      @game = Game.create!(slug: slug, stack: stack, big_blind: big_blind, small_blind: small_blind, timer: timer)
      @game.deal!
      return true
    rescue => e
      puts 'Error Setting up Game*' * 80
      puts e
      puts '*' * 80
      return false
    end

  end
end

class GamesController < ActionController::API
  def show
    render json: Game.find_by(slug: params[:id]).as_json
  end

  def next_hand
    if game.deal!
      HandsChannel.broadcast_to game, {newHandSeq: game.hands.last.sequence}
      render json: {newHandSeq: game.hands.last.sequence}
    else
      render json: { status: :failure }
    end
  end

  def update_form
    LobbysChannel.broadcast_to game, {playerOne: params[:playerOne] } if params[:playerOne]
    LobbysChannel.broadcast_to game, {playerTwo: params[:playerTwo] } if params[:playerTwo]
    if params[:stack]
      LobbysChannel.broadcast_to game, {stack: params[:stack] }
      game.update(stack: params[:stack])
    end

    if params[:timer]
      LobbysChannel.broadcast_to game, {timer: params[:timer] }
      game.update(timer: params[:timer])
    end

    if params[:blinds]
      LobbysChannel.broadcast_to game, {blinds: params[:blinds] }
      game.update(big_blind: params[:big_blind])
      game.update(small_blind: (params[:big_blind].to_i/2).floor)
    end

    if params[:playerOneReady]
      LobbysChannel.broadcast_to game, {playerOneReady: params[:playerOneReady], playerOne: params[:playerOne] }
      game.add_player(params[:playerOne], 1)
      game.save!
    end

    if params[:playerTwoReady]
      LobbysChannel.broadcast_to game, {playerTwoReady: params[:playerTwoReady],  playerTwo: params[:playerTwo] }
      game.add_player(params[:playerTwo], 2)
      game.save!
    end
    render json: {success: 'Form updated'}
  end

  def create
    creator = GameCreator.new(params)
    if creator.setup_game!
      render json: {gameId: creator.game.slug}
    else
      render json: {failure: 'Game failed to start'}
    end
  end

  def game
    @game ||= Game.find_by(slug: params[:game_id])
  end

end
