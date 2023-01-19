class GameChannel < ApplicationCable::Channel
  def subscribed
    # game = Game.find(params[:id])
    # stream_for game
    # Seek.create(game.id)
  end

  def unsubscribed
    # game = Game.find(params[:id])
    # Seek.remove(game.id)
    # Game.forfeit(game.id)
  end

  # def make_move(data)
  #   game = Game.find(params[:id])
  #   game.make_move(game.id, data)
  # end
end
