class Broker::ReocketChatsController < InheritedResources::Base
  before_filter :authenticate_broker!

  def create
    rocket_server = RocketChat::Server.new(ENV['ROCKET_CHAT_URL'])
    session = rocket_server.login('username', 'password')
    user = session.users.create('new_username', 'user@example.com', 'New User', '123456',
                                active: true, send_welcome_email: false)
    token = session.users.create_token(user_id: user.id)

  end
end
