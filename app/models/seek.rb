class Seek < ApplicationRecord
  # def self.create(uuid)
  #   if opponent = Redis.spop("seeks")
  #     Game.start(uuid, opponent)
  #   else
  #     Redis.sadd("seeks", uuid)
  #   end
  # end

  # def self.remove(uuid)
  #   Redis.srem("seeks", uuid)
  # end

  # def self.clear_all
  #   Redis.del("seeks")
  # end
end
