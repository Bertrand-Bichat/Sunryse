class Game < ApplicationRecord
  belongs_to :player1, class_name: 'User', foreign_key: "player1_id"
  belongs_to :player2, class_name: 'User', foreign_key: "player2_id"

  # def self.start(uuid1, uuid2)
  #   white, black = [uuid1, uuid2].shuffle

  #   ActionCable.server.broadcast "player_#{white}", { action: "game_start", msg: "white" }
  #   ActionCable.server.broadcast "player_#{black}", { action: "game_start", msg: "black" }

  #   Redis.set("opponent_for:#{white}", black)
  #   Redis.set("opponent_for:#{black}", white)
  # end

  # def self.forfeit(uuid)
  #   if winner == opponent_for(uuid)
  #     ActionCable.server.broadcast "player_#{winner}", { action: "opponent_forfeits" }
  #   end
  # end

  # def self.opponent_for(uuid)
  #   Redis.get("opponent_for:#{uuid}")
  # end

  # def self.make_move(uuid, data)
  #   opponent = opponent_for(uuid)
  #   move_string = "#{data['from']}-#{data['to']}"

  #   ActionCable.server.broadcast "player_#{opponent}", { action: "make_move", msg: move_string }
  # end
end
