module MessagingHelper
  require 'rest-client'
  @@dev = 'https://devadmin.jugendarbeit.digital/api'
  @@live = 'https://admin.jugendarbeit.digital/api'
  @@current_url = @@dev

  # Send message to given user using jugendinfo api
  #
  # @param title [String] title of the message
  # @param message [String] content of the message
  # @param device_token [Integer] user id on jugendinfo server
  # @param sendermail [String] email of broker sending message
  #
  # @return [Json] response from the jugendinfo server
  def self.send_message(title, message, device_token, sendermail)
    url = "#{@@current_url}/jugendinfo_push/send"
    response = RestClient.post url, api: 'ULv8r9J7Hqc7n2B8qYmfQewzerhV9p', message_title: title, message: message, device_token: device_token, sendermail: sendermail
    response
  end

  # Get conversation id for given user from jugendinfo api
  #
  # @param device_token [Integer] user id on jugendinfo server
  #
  # @return [Integer] conversation id
  def self.get_conversation_id(device_token)
    url = "#{@@current_url}/jugendinfo_message/get_conversation_id_by_user?user_id=#{device_token}"
    begin
      response = RestClient.get url
      json = JSON.parse(response)
      conversation_id = json['id']
      conversation_id
    rescue
      nil
    end
  end

  # Get messages corresponding to given user from jugendinfo api
  #
  # @param device_token [Integer] user id on jugendinfo server
  #
  # @return [Array<Json>] array of messages retrieved from jugendinfo server
  def self.get_messages(device_token)
    conversation_id = get_conversation_id(device_token)
    messages = []
    unless conversation_id.nil?
      url = "#{@@current_url}/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{conversation_id}&limit=1000"
      response = RestClient.get url
      json = JSON.parse(response.body)
      messages = json['messages'].sort_by {|val| DateTime.strptime(val['datetime'], '%s')}.reverse
    end

    messages
  end

  # Get last message corresponding to given user from jugendinfo api
  #
  # @param device_token [Integer] user id on jugendinfo server
  #
  # @return [<Json>] last message retrieved from jugendinfo server
  def self.get_last_message(device_token)
    conversation_id = get_conversation_id(device_token)
    logger.info "Conversation id is #{conversation_id}"
    message = nil
    unless conversation_id.nil?
      url = "#{@@current_url}/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{conversation_id}&last=1"
      response = RestClient.get url
      json = JSON.parse(response.body)
      messages = json['messages']
      message = messages[0] if messages.count > 0
    end

    message
  end
end