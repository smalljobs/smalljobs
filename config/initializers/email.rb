begin
  if Rails.env.development? || ENV['MAILCATCHER'] == 'true'
    sock = TCPSocket.new('localhost', 1025)
    sock.close

    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = { address: 'localhost', port: '1025' }
  end

rescue
  # Ignore and use normal dev mail settings
end
