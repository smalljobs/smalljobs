# require 'net/http'
# require 'uri'
# require 'json'

module RocketChat
  class Subscriptions

    attr_reader :error

    def initialize
      @errors = nil
    end

    # {
    #     "update": [
    #         {
    #             "t": "c",
    #             "ts": "2017-11-25T15:08:17.249Z",
    #             "name": "general",
    #             "fname": null,
    #             "rid": "GENERAL",
    #             "u": {
    #                 "_id": "EoyAmF4mxx5HxJHJB",
    #                 "username": "rocket.cat",
    #                 "name": "Rocket Cat"
    #             },
    #             "open": true,
    #             "alert": true,
    #             "unread": 1,
    #             "userMentions": 1,
    #             "groupMentions": 0,
    #             "_updatedAt": "2017-11-25T15:08:17.249Z",
    #             "_id": "5ALsG3QhpJfdMpyc8"
    #         }
    #     ],
    #     "remove": [],
    #     "success": true
    # }
    def get_unread(session, date=DateTime.new(2017,1,1,1,1,1,1,1))
      path = '/api/v1/subscriptions.get'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}?updatedSince=#{date.strftime('%FT%RZ')}")
      request = Net::HTTP::Get.new(uri)
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
      elsif response_json['success'] and response_json['update'].present?
        @error = nil
        {
            unread: response_json['update'].map{|x| x['unread'].to_i}.sum,
        }
      elsif response_json['success'] == false
        @error = response_json['error']
        @session = nil
        false
      else
        @error = 'Something went wrong'
        @session = nil
        false
      end
    end
  end
end
