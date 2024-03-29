RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.parent_controller = "::ApplicationController"

  config.authorize_with do
    redirect_to main_app.root_path unless current_admin != nil
  end

  config.model DefaultTemplate do
    list do
      field :template_name
    end

    edit do
      field :template_name
      field :template
    end
  end

  config.model Todo do
    list do
      field :record_id
      field :record_type
      field :manual_completion
      field :completed
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
      field :manual_completion
      field :completed
    end
  end

  config.model Todotype do
    list do
      field :title
      field :table
      field :manual_completion
    end

    edit do
      field :title
      field :description, :rich_editor do
        config(insert_many: true)
      end
      field :manual_completion
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
      # field :seeker
      field :userable
      field :expire_at
    end

    edit do
      field :access_token
      # field :seeker
      field :userable
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
      field :country
    end

    edit do
      group :place do
        label I18n.t('admin.groups.place')

        field :zip
        field :name
        field :country do
          required true
        end
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
        field :signature_on_contract
        field :wage_factor do
          help I18n.t('admin.groups.wage_factor')
        end
        field :salary_deduction
        field :hide_salary

        label I18n.t('admin.groups.vacation')
        field :start_vacation_date
        field :end_vacation_date
        field :vacation_active
        field :vacation_title
        field :vacation_text
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
        field :broker do
          required true
        end
      end

      group :messages do
        label I18n.t('admin.groups.messages')

        field :welcome_letter_employers_msg
        field :welcome_app_register_msg
        field :welcome_chat_register_msg
        field :not_receive_job_msg
        field :get_job_msg
        field :activation_msg
        field :welcome_email_for_parents_msg

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
      field :content
      field :contact_content
      field :ji_location_id do
        help "Optional. Separate ID's by comma ',' eg. 1,2"
      end
      field :ji_location_name do
        help "Optional. Separate names by comma ',' eg. name1,name2"
      end
      field :provider_contract_rules
      field :job_contract_rules
      field :detail_link
      field :country do
        required true
      end

      group :design do
        label I18n.t('admin.groups.design')

        field :logo do
          help I18n.t('admin.format.logo')
        end
        field :header_image do
          help I18n.t('admin.format.header_image')
        end
      end
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
      field :mobile
      field :email
      field :active
      field :confirmed
      field :rc_id
      field :rc_username
      field :created_by
      field :created_at
      field :updated_by
      field :updated_at
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
        field :update_prefs
        field :rc_id  do
          read_only true
        end
        field :rc_username  do
          read_only true
        end
        field :app_user_id  do
          read_only true
        end

      end

      group :employment do
        label I18n.t('admin.groups.employment')

        field :employments
      end

      group :administration do
        label I18n.t('admin.groups.administration')

        field :active
        field :role do
          partial "broker/role.html.haml"
        end
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
      field :mobile
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
      field :mobile
      field :email
      field :parent_email
      field :created_by
      field :created_at
      field :updated_by
      field :updated_at
    end

    edit do
      group :authenticatable do
        label I18n.t('admin.groups.authenticatable')

        field :login
        field :password
        field :password_confirmation
        field :date_of_birth
        field :sex
        field :rc_id  do
          read_only true
        end
        field :rc_username  do
          read_only true
        end
        field :app_user_id do
          read_only true
        end
        field :recovery_code do
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
        field :parent_email
        field :phone
        field :mobile
        field :additional_contacts
        field :contact_preference
        field :contact_availability
      end

      group :work do
        label I18n.t('admin.groups.work')
        field :work_categories
        field :certificates
        field :organization
        field :languages
        field :occupation
        field :occupation_end_date
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
      field :icon_name
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
    navigation_label I18n.t('admin.menu.certificate')

    list do
      field :title
    end

    edit do
      field :title
    end
  end

  config.model JobsCertificate do
    navigation_label I18n.t('admin.menu.jobs_certificate')
    list do
      field :content
      field :seeker

    end


    edit do
      field :content
      field :seeker

    end
  end

  config.model Country do
    list do
      field :id
      field :name
      field :alpha2
      field :regions

    end
  end

end
