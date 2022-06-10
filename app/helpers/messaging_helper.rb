module MessagingHelper
  def self.send_message(title, message, device_token, sendermail)
    #implement RC method to send messages
  end

  def self.return_proper_title title
    return "Jugendapp Nachricht" if title == "Nachricht senden"
    title
  end

  # Get messages corresponding to given user from jugendinfo api
  #
  # @param device_token [Integer] user id on jugendinfo server
  #
  # @return [Array<Json>] array of messages retrieved from jugendinfo server
  def self.get_messages(user_id, rc_username)
    messages = []
    se, im = RcSession.new(user_id).call
    room_id = im.create(se, [rc_username]).try(:dig, '_id')
    return messages if room_id.nil?
    history = im.history(se, room_id)
    return messages unless history
    messages = history.map do |history_element|
      {
        message: history_element.dig('msg'),
        u: history_element.dig('u'),
        datetime: history_element.dig('ts')
      }
    end
    messages.map(&:deep_symbolize_keys)
  end

  class RcSession
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      initialize_session
    end

    private

    def initialize_session
      se = RocketChat::Session.new(user_id)
      im = RocketChat::Im.new
      [se, im]
    end
  end

end
