if Rails.env.development? || Rails.env.test?
  require 'fabrication'

  ActionDispatch::Callbacks.after do
    Fabrication.clear_definitions
  end
end

