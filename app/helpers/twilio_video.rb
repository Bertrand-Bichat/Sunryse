require 'twilio-ruby'

class TwilioVideo < ApplicationRecord

  def self.create_room(room_name)
    client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
    room = client.video.rooms.create(unique_name: room_name)

    return room
  end

  def self.get_room(room_name)
    client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
    room = client.video.rooms(room_name).fetch

    return room
  end

  def self.access_token(user)
    # Create an Access Token
    token = Twilio::JWT::AccessToken.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_API_KEY"], ENV["TWILIO_API_SECRET"],
        ttl: 7200, # ONE YEAR LIFE TIME FOR A TOKEN
        identity: user

    # Grant access to Video
    # grant = Twilio::JWT::AccessToken::VideoGrant.new
    # grant.room = room_name
    # @token.add_grant grant
    return token
  end

  def self.grant_room_access(token, room_name)
    # Grant access to Video room
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = room_name
    token.add_grant grant
    return token.to_jwt
  end

  def self.find_by_unique_name(name)
    client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])

    rooms = client.video.rooms.list(unique_name: name, limit: 20)

    # rooms.each do |record|
      # puts record.sid
    # end
    return rooms
  end

end
