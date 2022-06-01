module RocketChat
  class Room


    attr_reader :error

    def initialize
      @errors = nil
    end

    # user_names Array
    # @room = {
    # "_id"=>"vJGZc7bTyy4tWeF8a",
    # "name"=>"nachricht-2158965e3b275da5d9beda10f1231ee8",
    # "fname"=>"Nachricht 2158965e3b275da5d9beda10f1231ee8",
    # "t"=>"p", "msgs"=>2, "usersCount"=>3,
    # "u"=>{"_id"=>"pHpNpkpho8JgMYQXc", "username"=>"smalljobs_dev_2"},
    # "customFields"=>{},
    # "ts"=>"2020-09-30T07:39:29.247Z",
    # "ro"=>false, "_updatedAt"=>"2020-09-30T07:39:29.451Z"
    # }
    def create(session, user_names, region_name)
      path = '/api/extras/room.create'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = session.data[:auth_token]
      request["X-User-Id"] = session.data[:user_id]
      seekers = Seeker.where(rc_username: user_names)
      users = seekers.map{|x| {id: x.rc_id}}
      request.body = JSON.dump({
                                   "name" => "Jobs #{region_name} #{session.broker.try(:first_name)} #{SecureRandom.hex}",
                                   'users' => users,
                                   'broadcast' => true
                               })

      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)

      if response_json['errorStrings'].present?
        @error = response_json['errorStrings'].last
        false
      elsif response_json['_id'].present?
        @error = nil
        response_json
      else
        @error = 'Something went wrong'
        false
      end
    end
  end
end
