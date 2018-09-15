class GameCreator
  def game
    white = cards.pop(2)
    black = cards.pop(2)
    position = {cards: cards, knights: [[7,0], [7,7], [0,0], [0,7]]}
    Game.create!(position: position, white: white, black: black)
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
    game = Game.last #Game.find_by(id: params[:id]) || GameCreator.new.game

    cards = game.position[:cards]
    knights = game.position[:knights]
    white = game.white
    black = game.black

    render json: {white: {hand: white},
                  black: {hand: black},
                  knights: knights,
                  cards: cards }
  end

  def move
    #game = Game.find_by(id: params[:id])
    #game.moves.create(order: game.moves.count + 1, move: '', color: '')
    puts params
  end

  def cards
    suits = ['♠', '♥', '♦', '♣']
    num = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.map{|suit| num.map{|rank| rank + suit }}.flatten.shuffle
  end
end
