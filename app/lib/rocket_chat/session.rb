module RocketChat
  class Session

    attr_reader :data
    # data = {
    # user_id: .....
    # auth_token: .....
    # username: ....
    # }
    def initialize(user_id)
      rc = RocketChat::Users.new
      auth_info = rc.create_token(user_id)
      user_name = rc.info(user_id)
      @data = auth_info.merge(user_name)
    end
  end
end