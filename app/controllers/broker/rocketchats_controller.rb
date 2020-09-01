class Broker::RocketchatsController < InheritedResources::Base

  before_filter :authenticate_broker!

  def create
    rc = RocketChat::Users.new
    answer = rc.create_token(current_broker.rc_id)
    respond_to do |format|
      if answer
        format.json { render json: answer.merge({url: ENV['ROCKET_CHAT_URL']}), status: :ok }
      else
        format.json { render json: { error: rc.error }, status: :unprocessable_entity }
        end
    end
  end

  def room
    se = RocketChat::Session.new(current_broker.rc_id)
    im = RocketChat::Im.new
    answer = im.create(se, [params[:rc_username]])
    respond_to do |format|
      if answer
        format.json { render json: {id: answer['_id']}, status: :ok }
      else
        format.json { render json: { error: im.error }, status: :unprocessable_entity }
      end
    end
  end

  def message
    se = RocketChat::Session.new(current_broker.rc_id)
    message = RocketChat::Chat.new
    answer = message.create(se, [params[:rc_username]], params[:message])
    respond_to do |format|
      if answer
        format.json { render json: {id: answer['_id']}, status: :ok }
      else
        format.json { render json: { error: message.error }, status: :unprocessable_entity }
      end
    end
  end

end
