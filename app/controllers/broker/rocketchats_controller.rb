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
        format.json { render json: {id: answer['_id'], user_token: current_broker.rc_token}, status: :ok }
      else
        format.json { render json: { error: im.error }, status: :unprocessable_entity }
      end
    end
  end

  def broadcast_room
    se = RocketChat::Session.new(current_broker.rc_id)
    room = RocketChat::Room.new
    answer = room.create(se, params[:rc_usernames], current_region.try(:name))
    respond_to do |format|
      if answer
        format.json { render json: {name: answer['name']}, status: :ok }
      else
        format.json { render json: { error: room.error }, status: :unprocessable_entity }
      end
    end
  end

  def message
    broadcast_message = current_broker.broadcast_messages.where("created_at > ?", DateTime.now-1.hour).find_or_create_by(message: params[:message])
    se = RocketChat::Session.new(current_broker.rc_id)
    message = RocketChat::Chat.new
    answer = message.create(se, [params[:rc_username]], params[:message])
    if answer
      BroadcastMessageSeeker.create(seeker_id: params[:seeker_id], broadcast_message_id: broadcast_message.id)
    end
    respond_to do |format|
      if answer
        format.json { render json: {id: answer['_id']}, status: :ok }
      else
        format.json { render json: { error: message.error }, status: :unprocessable_entity }
      end
    end
  end


  def unread
    se = RocketChat::Session.new(current_broker.rc_id)
    subscription = RocketChat::Subscriptions.new
    answer = subscription.get_unread(se)
    respond_to do |format|
      if answer
        format.json { render json: {unread: answer[:unread]}, status: :ok }
      else
        format.json { render json: { error: message.error }, status: :unprocessable_entity }
      end
    end

  end

  def update_unread_messages
    broker = Broker.find_by(rc_id: params[:broker_id])
    seeker = Seeker.find_by(rc_username: params[:seeker_username])
    respond_to do |format|
      if broker.present? && seeker.present?
        um = UnreadMessage.find_by(broker_id: broker.id, seeker_id: seeker.id)
        datetime_param = Time.at(params[:timestamp].to_i / 1000).to_s
        datetime_without_tz = DateTime.strptime(datetime_param, '%Y-%m-%d %H:%M:%S %z').new_offset(0) + 2.hours
        if um.update(last_message_timestamp: datetime_without_tz)
          format.json { render json: { msg: 'ok' }, status: :ok }
        else
          format.json { render json: { error: um.error }, status: :unprocessable_entity }
        end
      else
        format.json { render json: { msg: 'User not found' }, status: :not_found }
      end
    end
  end
end
