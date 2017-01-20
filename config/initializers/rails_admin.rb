RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.model Place do
    navigation_label I18n.t('admin.menu.geo')

    list do
      field :zip
      field :name
      field :province
      field :state
    end

    edit do
      group :place do
        label I18n.t('admin.groups.place')

        field :zip
        field :name
      end

      group :political do
        label I18n.t('admin.groups.political')

        field :province
        field :state
      end

      group :position do
        label I18n.t('admin.groups.position')

        field :longitude
        field :latitude
      end
    end
  end

  config.model Organization do
    navigation_label I18n.t('admin.menu.org')
    weight 0

    list do
      field :name
      field :website
      field :email
      field :phone
    end

    edit do
      group :organization do
        label I18n.t('admin.groups.organization')

        field :name
        field :description
        field :website
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :street
        field :place
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :phone
        field :email
      end

      group :brokers do
        label I18n.t('admin.groups.brokers')

        field :employments
      end

      group :design do
        label I18n.t('admin.groups.design')

        field :logo do
          help I18n.t('admin.format.logo')
        end

        field :background do
          help I18n.t('admin.format.background')
        end
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
      end
    end
  end

  config.model Region do
    navigation_label I18n.t('admin.menu.org')
    weight 5

    list do
      field :name
      field :subdomain
      field :places
    end

    edit do
      field :name
      field :subdomain
      field :places
    end
  end

  config.model Employment do
    navigation_label I18n.t('admin.menu.org')
    weight 10

    list do
      field :organization
      field :broker
      field :region
    end
  end

  config.model Admin do
    navigation_label I18n.t('admin.menu.user')
    weight 0

    list do
      field :email
      field :sign_in_count
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :email
        field :password
      end
    end
  end

  config.model Broker do
    navigation_label I18n.t('admin.menu.user')
    weight 5

    list do
      field :firstname
      field :lastname
      field :phone
      field :email
      field :active
      field :confirmed
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :email
        field :password
        field :password_confirmation
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :firstname
        field :lastname
        field :phone
        field :mobile

        field :contact_availability
      end

      group :employment do
        label I18n.t('admin.groups.employment')

        field :employments
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
        field :confirmed, :boolean
        # field :terms, :boolean
      end
    end
  end

  config.model Provider do
    navigation_label I18n.t('admin.menu.user')
    weight 10

    list do
      field :firstname
      field :lastname
      field :phone
      field :email
      field :active
      field :confirmed
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :username
        field :password
        field :password_confirmation
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :place
      end

      group :contact do
        label I18n.t('admin.groups.contact')
        field :email
        field :phone
        field :mobile
        field :contact_preference
        field :contact_availability
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
        field :confirmed, :boolean
        field :terms, :boolean
      end
    end
  end

  config.model Seeker do
    navigation_label I18n.t('admin.menu.user')
    weight 15

    list do
      field :firstname
      field :lastname
      field :phone
      field :email
      field :active
      field :confirmed
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :email
        field :password
        field :password_confirmation
        field :date_of_birth
        field :sex
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :place
      end

      group :contact do
        label I18n.t('admin.groups.contact')
        field :phone
        field :mobile
        field :contact_preference
        field :contact_availability
      end

      group :work do
        label I18n.t('admin.groups.work')
        field :work_categories
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
        field :confirmed, :boolean
        field :terms, :boolean
      end
    end
  end

  config.model WorkCategory do
    navigation_label I18n.t('admin.menu.job')

    list do
      field :name
    end

    edit do
      field :name
    end
  end

  config.model Allocation do
    navigation_label I18n.t('admin.menu.application')

    list do
      field :job
      field :seeker
      field :state
      field :feedback_seeker
      field :feedback_provider
      field :contract_returned

      field :created_at do
        date_format :short
      end
    end

    edit do
      field :job
      field :seeker
      field :state
      field :feedback_seeker
      field :feedback_provider
      field :contract_returned
    end
  end

  config.model Job do
    navigation_label I18n.t('admin.menu.job')

    list do
      field :provider
      field :title
      field :place

      field :allocations
      field :applications
      field :proposals
      field :reviews

      field :created_at do
        date_format :short
      end
    end

    edit do
      group :job do
        label I18n.t('admin.groups.job')

        field :provider
        field :work_category
        field :title
        field :description
      end

      group :date do
        label I18n.t('admin.groups.date')

        field :date_type
        field :start_date
        field :end_date
      end

      group :salary do
        label I18n.t('admin.groups.salary')

        field :salary_type
        field :salary
      end

      group :seekers do
        label I18n.t('admin.groups.seekers')

        field :manpower
        field :duration
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :state
        field :rating_reminder_sent
      end
    end
  end
end
