module RocketChat
  class Chat

    attr_reader :error

    def initialize
      @errors = nil
    end

    # user_names Array
    # message String
    # request = {
    #   "ts": 1481748965123,
    #   "channel": "general",
    #   "message": {
    #     "alias": "",
    #     "msg": "This is a test!",
    #     "parseUrls": true,
    #     "groupable": false,
    #     "ts": "2016-12-14T20:56:05.117Z",
    #     "u": {
    #       "_id": "y65tAmHs93aDChMWu",
    #       "username": "graywolf336"
    #     },
    #     "rid": "GENERAL",
    #     "_updatedAt": "2016-12-14T20:56:05.119Z",
    #     "_id": "jC9chsFddTvsbFQG7"
    #   },
    #   "success": true
    # }
    def create(session, user_names, message)
      im = RocketChat::Im.new
      answer = im.create(session, user_names)
      if answer
        room_id = answer["_id"]

        path = '/api/v1/chat.postMessage'
        uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request["X-Auth-Token"] = session.data&.fetch(:auth_token)
        request["X-User-Id"] = session.data&.fetch(:user_id)
        request.body = JSON.dump({
                                     "roomId" => room_id,
                                     "text" => message
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
        elsif response_json['success'] and response_json['ts'].present?
          @error = nil
          {"_id": room_id}
        elsif  response_json['success'] == false
          @error = response_json['error']
          false
        else
          @error = 'Something went wrong'
          false
        end
      else
        @error = im.error
        false
      end
    end
  end
end
