# require 'net/http'
# require 'uri'
# require 'json'

module RocketChat
  class Im

    attr_reader :error

    def initialize
      @errors = nil
    end

    # user_names Array
    # @room = {
    #           "t": "d",
    #           "rid": "PMrDaS4axRqkjY7errocket.cat",
    #           "usernames": [
    #                "g1",
    #                "rocket.cat"
    #           ],
    #     "_id"=>"PMrDaS4axRqkjY7errocket.cat"
    #     }
    def create(session, user_names)
      path = '/api/v1/im.create'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = session.data[:auth_token]
      request["X-User-Id"] = session.data[:user_id]
      request.body = JSON.dump({
                                   "usernames" => user_names.join(',')
                               })

      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)
      if response_json['status'].present? and response_json['status'] == "error"
        @error = response_json['message']
        false
      elsif response_json['success'] and response_json['room'].present?
        @error = nil
        response_json['room']
      elsif  response_json['success'] == false
        @error = response_json['error']
        false
      else
        puts response_json
        @error = 'Something went wrong'
        false
      end
    end

    def history(session, room_id)
      path = '/api/v1/im.history'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}?roomId=#{room_id}")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = session.data[:auth_token]
      request["X-User-Id"] = session.data[:user_id]

      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)
      if response_json['status'].present? and response_json['status'] == "error"
        @error = response_json['message']
        false
      elsif response_json['success'] and response_json['messages'].present?
        @error = nil
        response_json['messages']
      elsif  response_json['success'] == false
        @error = response_json['error']
        false
      else
        puts response_json
        @error = 'Something went wrong'
        false
      end
    end

    def send_message(message, room_id, rc_username)
      path = '/api/v1/chat.postMessage'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = session.data[:auth_token]
      request["X-User-Id"] = session.data[:user_id]

      request.body = JSON.dump(
        {
          'roomId' => room_id,
          'channel' => "@#{rc_username}",
          'text' => message
        }
      )

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
  end
end
