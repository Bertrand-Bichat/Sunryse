class GamePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    if user_loggedin?
      (record.player1 == user) || (record.player2 == user)
    end
  end
end
