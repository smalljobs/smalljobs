# app/models/concerns/auditable.rb

module Auditable
  extend ActiveSupport::Concern

  included do
    # Assigns created_by_id and updated_by_id upon included Class initialization
    after_save :add_created_by_and_updated_by


    enum creator_type: {
      admin: 'admin',
      provider: 'provider',
      broker: 'broker',
      seeker: 'seeker'
    }, _prefix: true

    enum updater_type: {
      admin: 'admin',
      provider: 'provider',
      broker: 'broker',
      seeker: 'seeker'
    }, _prefix: true

    def created_by
      user = user(created_by_id, creator_type)
      user_name(user)
    end

    def updated_by
      user = user(updated_by_id, updater_type)
      user_name(user)
    end
  end

  private

  def user_name(user)
    return unless user
    if user.email.present?
      user.email
    elsif user.class.name != 'Admin'
      "#{user.firstname} #{user.lastname}"
    end
  end

  def user(id, user_role)
    return nil unless user_role
    model = Object.const_get user_role.capitalize
    model.find(id)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error '-----------------'
    Rails.logger.error "User not found #{e.inspect}"
    Rails.logger.error '-----------------'
    nil
  end

  def add_created_by_and_updated_by
    return unless Current.user
    user_role = Current.user.class.name.downcase
    user_id = Current.user.id
    self.ji_request = true
    if created_by_id.nil? && creator_type.nil?
      update_columns(
        created_by_id: user_id,
        creator_type: user_role,
        updated_by_id: user_id,
        updater_type: user_role)
    else
      update_columns(updated_by_id: user_id, updater_type: user_role)
    end
  rescue ArgumentError => e
    Rails.logger.error '-------------------------'
    Rails.logger.error "User role is invalid #{e.inspect}"
    Rails.logger.error '-------------------------'
  end
end
