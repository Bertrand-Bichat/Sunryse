class GamesController < ApplicationController

  def index
    @games = policy_scope(Game).where(player1: current_user).or(policy_scope(Game).where(player2: current_user)).order(id: :asc)
  end

  def show
    @game = authorize policy_scope(Game).find(params[:id])
    @games = policy_scope(Game).where(player1: current_user).or(policy_scope(Game).where(player2: current_user)).order(id: :asc)

    if current_user == @game.player1
      @other_speaker = @game.player2
    else
      @other_speaker = @game.player1
    end
  end
end
