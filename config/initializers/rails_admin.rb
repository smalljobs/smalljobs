RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.authorize_with do
    redirect_to main_app.root_path unless current_admin != nil
  end

  config.model Todo do
    list do
      field :record_id
      field :record_type
    end

    edit do
      field :record_id do
        read_only true
      end
      field :record_type do
        read_only true
      end
      field :created_at do
        read_only true
      end
      field :todotype do
        read_only true
      end
    end
  end

  config.model Todotype do
    list do
      field :title
      field :table
    end

    edit do
      field :title
      field :description, :rich_editor do
        config(insert_many: true)
      end
      field :table
      field :where, :text
    end
  end

  config.model Help do
    list do
      field :title
      field :url
    end

    edit do
      field :title
      field :description, :rich_editor do
        config({
                   :insert_many => true
               })
      end
      field :url
    end
  end

  config.model AccessToken do
    list do
      field :access_token
      field :seeker
      field :expire_at
    end

    edit do
      field :access_token
      field :seeker
      field :expire_at
    end
  end

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
        field :opening_hours
        field :website
        field :wage_factor do
          help I18n.t('admin.groups.wage_factor')
        end
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

      group :messages do
        label I18n.t('admin.groups.messages')

        field :welcome_letter_employers_msg
        field :welcome_app_register_msg
        field :welcome_chat_register_msg
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
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :email
        field :password
        field :password_confirmation
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :company
        field :firstname
        field :lastname
        field :street
        field :place
        field :organization
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

        field :notes
        field :state
        field :active
        field :terms, :boolean
      end
    end
  end

  config.model Seeker do
    navigation_label I18n.t('admin.menu.user')
    weight 15

    list do
      field :id
      field :firstname
      field :lastname
      field :phone
      field :email
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :login
        field :password
        field :password_confirmation
        field :date_of_birth
        field :sex
        field :app_user_id do
          read_only true
        end
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :place
        field :organization
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :email
        field :phone
        field :mobile
        field :contact_preference
        field :contact_availability
      end

      group :work do
        label I18n.t('admin.groups.work')
        field :work_categories
        field :certificates
        field :organization
      end

      group :administration do
        label I18n.t('admin.groups.administration')
        field :notes
        field :status
        field :parental
        field :discussion
        # field :terms, :boolean
      end
    end

    show do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :login
        field :password
        field :password_confirmation
        field :date_of_birth
        field :sex
        field :app_user_id do
          read_only true
        end
      end

      group :address do
        label I18n.t('admin.groups.address')

        field :firstname
        field :lastname
        field :street
        field :place
        field :organization
      end

      group :contact do
        label I18n.t('admin.groups.contact')

        field :email
        field :phone
        field :mobile
        field :contact_preference
        field :contact_availability
      end

      group :work do
        label I18n.t('admin.groups.work')
        field :work_categories
        field :organization
      end

      group :administration do
        label I18n.t('admin.groups.administration')
        field :notes
        field :status
        # field :terms, :boolean
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

  config.model Assignment do
    navigation_label I18n.t('admin.menu.assignment')

    list do
      field :status

      field :provider
      field :seeker
      field :job

      field :feedback
    end

    edit do
      field :provider
      field :seeker
      field :job

      field :status
      field :feedback
      field :start_time
      field :end_time
      field :duration
    end
  end

  config.model Job do
    navigation_label I18n.t('admin.menu.job')

    list do
      field :provider
      field :title
      field :place

      field :allocations

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
        field :short_description
        field :long_description
        field :notes
        field :organization
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

  config.model Certificate do
    navigation_label 'Zertifikate'

    list do
      field :title
    end

    edit do
      field :title
    end
  end
end
