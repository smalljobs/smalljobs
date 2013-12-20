require 'rails_admin_impersonate'

RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']
  config.authorize_with :cancan

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

      group :brokers do
        label I18n.t('admin.groups.brokers')

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

    edit do
      field :name
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
      field :confirmed?
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

      group :employment do
        label I18n.t('admin.groups.employment')

        field :employments
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
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
      field :confirmed?
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

  config.model Seeker do
    navigation_label I18n.t('admin.menu.user')
    weight 15

    list do
      field :firstname
      field :lastname
      field :phone
      field :email
      field :active
      field :confirmed?
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :email
        field :password
        field :date_of_birth, :string
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
end
