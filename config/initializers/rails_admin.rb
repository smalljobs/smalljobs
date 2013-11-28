RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.authenticate_with do
    authenticate_admin!
  end

  config.current_user_method { current_admin }

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

        field :map
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
      field :city
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
        field :zip
        field :city
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :phone
        field :email
      end

      group :job_brokers do
        label I18n.t('admin.groups.job_brokers')

        field :employments
      end

      group :design do
        label I18n.t('admin.groups.design')

        field :logo
        field :background
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
      field :places
    end
  end

  config.model Employment do
    navigation_label I18n.t('admin.menu.org')
    weight 10

    list do
      field :organization
      field :job_broker
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

  config.model JobBroker do
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
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :firstname
        field :lastname
        field :phone
        field :mobile
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
      end
    end
  end

  config.model JobProvider do
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
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :zip
        field :city
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
      end
    end
  end

  config.model JobSeeker do
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
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :zip
        field :city
        field :date_of_birth
      end

      group :contact do
        label I18n.t('admin.groups.contact')
        field :phone
        field :mobile
        field :contact_preference
        field :contact_availability
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
      end
    end
  end

  config.model WorkCategory do
    navigation_label I18n.t('admin.menu.job')

    list do
      field :name
    end
  end
end
