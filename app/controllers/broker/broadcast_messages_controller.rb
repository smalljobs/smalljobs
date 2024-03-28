class Broker::BroadcastMessagesController < InheritedResources::Base

  before_filter :authenticate_broker!


  def last_message
    @broadcast_messages = current_broker.broadcast_messages.order(created_at: :desc).limit(10)

    json_array = []

    @broadcast_messages.each do |broadcast_message|
      json_array.push({
        message: broadcast_message.message,
        created_at: broadcast_message.created_at.strftime("%Y.%m.%d"),
        seekers: broadcast_message.seekers.map{|x| x.name}
      })
    end

    respond_to do |format|
      if @broadcast_messages.present?
        format.json { render json: json_array , status: :ok}
      else
        format.json { render json: { error: I18n.t('broadcast_messages.no_message_found') }, status: :unprocessable_entity}
      end
    end
  end

end
