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
      @game = Game.create(slug: slug, stack: stack, big_blind: big_blind, small_blind: small_blind, timer: timer)
      @game.add_player(player_one)
      @game.add_player(player_two)
      @game.deal!
      return true
    rescue => e
      puts '*' * 80
      puts e
      puts '*' * 80
      return false
    end

  end
end

class GamesController < ActionController::API
  def create
    creator = GameCreator.new(params)
    if creator.setup_game!
      render json: {success: 'Game Starting'}
    else
      render json: {failure: 'Game failed to start'}
    end
  end
end
