class Broker::BroadcastMessagesController < InheritedResources::Base

  before_filter :authenticate_broker!


  def last_message
    @broadcast_message = current_broker.broadcast_messages.order(created_at: :desc).limit(1).first
    respond_to do |format|
      if @broadcast_message.present?
        format.json { render json: { message: @broadcast_message.message, seekers: @broadcast_message.seekers.map{|x| x.name} }, status: :ok}
      else
        format.json { render json: { error: I18n.t('broadcast_messages.no_message_found') }, status: :unprocessable_entity}
      end
    end
  end

end
