# require 'net/http'
# require 'uri'
# require 'json'

module RocketChat
  class Users

    attr_reader :error, :total_records

    def initialize
      @errors = nil
      @total_records = nil
    end

    def create_token(user_id)
      path = '/api/v1/users.createToken'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']
      request.body = JSON.dump({
                                   "userId" => user_id
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
      elsif response_json['success'] and response_json['data'].present?
        @error = nil
        {
            user_id: response_json['data']['userId'],
            auth_token: response_json['data']['authToken'],
        }

      elsif response_json['success'] == false
        @error = response_json['error']
        false
      else
        @error = 'Something went wrong'
        false
      end
    end

    # user = {
    # "name": "name",
    # "email": "email@user.tld",
    # "password": "anypassyouwant",
    # "username": "uniqueusername",
    # "smalljobs_user_id": 1  # custom_fields
    #   # To save customFields you must first define the customFields in admin panel
    #   # (Accounts -> Registration -> Custom fields).
    # }
    def create(user)
      path = '/api/v1/users.create'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']
      request.body = JSON.dump(user)

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
      elsif response_json['success'] and response_json['user'].present?
        @error = nil
        {
            user_id: response_json['user']['_id'],
            user_name: response_json['user']['username'],
        }
      elsif response_json['success'] == false
        @error = response_json['error']
        false
      else
        @error = 'Something went wrong'
        @data = nil
        false
      end
    end

    def info(user_id, arg="userId")
      path = '/api/v1/users.info'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}?#{arg}=#{user_id}")
      request = Net::HTTP::Get.new(uri)
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']


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
      elsif response_json['success'] and response_json['user'].present?
        @error = nil
        {
            user_id: response_json['user']['_id'],
            user_name: response_json['user']['username'],
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

    def delete(user_id)
      path = '/api/v1/users.delete'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']
      request.body = JSON.dump({
                                   "userId" => user_id
                               })

      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)
      if response_json['success'].present? and response_json['success'] == true
        true
      else
        @error = 'Something went wrong'
        false
      end
    end


    # user = {
    # "name": "name",
    # "email": "email@user.tld",
    # "password": "anypassyouwant",
    # "username": "uniqueusername",
    #  "rc_id": "casdas12"
    # "smalljobs_user_id": 1  # custom_fields
    #   # To save customFields you must first define the customFields in admin panel
    #   # (Accounts -> Registration -> Custom fields).
    # }
    def update(user)
      path = '/api/v1/users.update'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']
      request.body = JSON.dump({
                                   "userId" => user.delete('rc_id'),
                                   "data" => user
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
      elsif response_json['success'] and response_json['user'].present?
        @error = nil
        {
            user_id: response_json['user']['_id'],
            user_name: response_json['user']['username'],
        }
      elsif response_json['success'] == false
        @error = response_json['error']
        false
      else
        @error = 'Something went wrong'
        @data = nil
        false
      end
    end


    def list(offset=0, count=100)
      path = '/api/v1/users.list'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}?fields={ \"username\":1, \"emails\":1 }&offset=#{offset}&count=#{count}")
      request = Net::HTTP::Get.new(uri)
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']


      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)
      # return response_json
      if response_json['status'].present? and response_json['status'] == "error"
        @error = response_json['message']
        false
      elsif response_json['success'] and response_json['users'].present?
        @error = nil
        @total_records = response_json['total']
        response_json['users']
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

    def get_all_users
      offset = 0
      count = 100
      users = list(offset, count)
      while @total_records > users.length
        next_users = list(offset+=count, count)
        users += next_users if next_users
      end
      return users
    end

    def find_user_by_email(email)
      offset = 0
      count = 1
      path = '/api/v1/users.list'
      uri = URI.parse("#{ENV['ROCKET_CHAT_URL']}#{path}?fields={ \"username\":1, \"emails\":1 }&offset=#{offset}&count=#{count}&query={\"emails\":{\"$elemMatch\": {\"address\" : {\"$eq\":\"#{email}\"}}}}")
      request = Net::HTTP::Get.new(uri)
      request["X-Auth-Token"] = ENV['ROCKET_CHAT_USER_TOKEN']
      request["X-User-Id"] = ENV['ROCKET_CHAT_USER_ID']


      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      #response.code
      response_json = JSON.parse(response.body)
      # return response_json
      if response_json['status'].present? and response_json['status'] == "error"
        @error = response_json['message']
      elsif response_json['success'] and response_json['users'].present?
        @error = nil
        @total_records = response_json['total']
        users = response_json['users']
        users.each do |user|
          if user['emails'].present? and email == user['emails'][0]['address']
            return {rc_id: user["_id"], rc_username: user["username"]}
          end
        end
      elsif response_json['success'] == false
        @error = response_json['error']
        @session = nil
      else
        @error = 'Something went wrong'
        @session = nil
      end
      return nil
    end

  end
end
