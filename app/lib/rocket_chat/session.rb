module RocketChat
  class Session

    attr_reader :data, :broker
    # data = {
    # user_id: .....
    # auth_token: .....
    # username: ....
    # }
    def initialize(user_id)
      @broker = Broker.find_by_rc_id(user_id)
      rc = RocketChat::Users.new
      auth_info = rc.create_token(user_id)
      if auth_info
        user_name = rc.info(user_id)
        @data = auth_info.merge(user_name)
      end
    end
  end
end
