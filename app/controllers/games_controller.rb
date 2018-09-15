class GameCreator
  def game
    white = cards.pop(2)
    black = cards.pop(2)
    starting_pos = [ [[7,0], [7,7], [0,0], [0,7]] ]
    Game.create!(cards: cards, position: starting_pos, white: white, black: black)
  end

  def cards
    @cards ||= begin
      suits = ['♠', '♥', '♦', '♣']
      num = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
      suits.map{|suit| num.map{|rank| rank + suit }}.flatten.shuffle
    end
  end
end

class GamesController < ActionController::API
  def index
    render json: {board: ['index']}
  end

  def show
    game = Game.find_by(id: params[:id]) || GameCreator.new.game

    cards = game.cards
    knights = game.position.last
    white = game.white
    black = game.black

    render json: {white: {hand: white},
                  black: {hand: black},
                  knights: knights,
                  cards: cards }
  end

  def move
    game = Game.last
    position = params[:game][:position]
    move = params[:game][:move]
    game.add_move(position, move)
    #game = Game.find_by(id: params[:id])
    if game.save
      render json: {success: true }
    else
      render json: {failure: true }
    end
  end

  def cards
    suits = ['♠', '♥', '♦', '♣']
    num = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.map{|suit| num.map{|rank| rank + suit }}.flatten.shuffle
  end
end
