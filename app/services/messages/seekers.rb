module Messages
  class Seekers

    def self.first_reminder_to_inactive
      seekers = Seeker.where(status: :inactive, parental: false, discussion: false).
          where(first_date_message_to_inactive: nil).where("created_at < ?", Date.today - 29.days).
          where.not(rc_id: [nil,''])
      seekers.each do |seeker|
        organization = seeker.organization
        broker = organization.try(:broker)
        if organization.present?
          message = Mustache.render(organization.first_reminder_message || '',
                                    seeker_first_name: seeker.firstname,
                                    organization_name: organization.name,
                                    organization_street: organization.street,
                                    organization_zip: organization.try(:place).try(:zip),
                                    organization_place: organization.try(:place).try(:name),
                                    organization_opening_hours: organization.opening_hours,
                                    organization_phone: organization.phone,
                                    organization_email: organization.email)
        else
          message = ''
        end
        if broker.present?
          se = RocketChat::Session.new(broker.rc_id)
          chat = RocketChat::Chat.new
          chat.create(se, [seeker.rc_username], message)
          seeker.first_date_message_to_inactive = Date.today
          seeker.save
        end
      end
    end

    def self.second_reminder_to_inactive
      seekers = Seeker.where(status: :inactive, parental: false, discussion: false).
          where(first_date_message_to_inactive:  Date.today - 30.days).
          where.not(rc_id: [nil,''])
      seekers.each do |seeker|
        organization = seeker.organization
        broker = organization.try(:broker)
        if organization.present?
          message = Mustache.render(organization.second_reminder_message || '',
                                    seeker_first_name: seeker.firstname,
                                    organization_name: organization.name,
                                    organization_street: organization.street,
                                    organization_zip: organization.try(:place).try(:zip),
                                    organization_place: organization.try(:place).try(:name),
                                    organization_opening_hours: organization.opening_hours,
                                    organization_phone: organization.phone,
                                    organization_email: organization.email)
        else
          message = ''
        end
        if broker.present?
          se = RocketChat::Session.new(broker.rc_id)
          chat = RocketChat::Chat.new
          chat.create(se, [seeker.rc_username], message)
          seeker.status = :completed
          seeker.save
        end
      end
    end
  end
end
