module ConfirmToggle
  extend ActiveSupport::Concern

  # Set the confirmation state
  #
  # @param [Boolean] status wether the user email is confirmed or not
  #
  def confirmed=(status)
    if confirmed? && (status == false || status == '0' || status == 0)
      update_attributes(confirmed_at: nil)

    elsif !confirmed? && (status == true || status == '1' || status == 1)
      update_attributes(confirmation_token: nil, confirmed_at: Time.now.utc)
    end
  end

  included do
    alias_method :confirmed, :confirmed?
  end
end
