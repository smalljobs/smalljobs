module MessagingHelper
  require 'rest-client'
  @@dev = 'https://devadmin.jugendarbeit.digital/api'
  @@live = 'https://admin.jugendarbeit.digital/api'
  @@current_url = @@live

  def self.send_message(title, message, device_token, sendermail)
    url = "#{@@current_url}/jugendinfo_push/send"
    response = RestClient.post url, api: 'ULv8r9J7Hqc7n2B8qYmfQewzerhV9p', message_title: title, message: message, device_token: device_token, sendermail: sendermail
    response
  end

  def self.get_conversation_id(device_token)
    url = "#{@@current_url}/jugendinfo_message/get_conversation_id_by_user?user_id=#{device_token}"
    response = RestClient.get url
    json = JSON.parse(response)
    conversation_id = json['id']
    conversation_id
  end

  def self.get_messages(device_token)
    conversation_id = get_conversation_id(device_token)
    messages = []
    unless conversation_id.nil?
      url = "#{@@current_url}/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{conversation_id}&limit=1000"
      response = RestClient.get url
      json = JSON.parse(response.body)
      messages = json['messages'].sort_by { |val| DateTime.strptime(val['datetime'], '%s') }.reverse
    end

    messages
  end
end