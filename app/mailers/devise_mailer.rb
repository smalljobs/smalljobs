class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :mailer
end
