class DeviseCreateJobProviders < ActiveRecord::Migration
  def change
    create_table(:job_providers) do |t|
      t.string :email

      t.string :firstname, null: false
      t.string :lastname, null: false

      t.string :street, null: false
      t.string :zip, null: false
      t.string :city, null: false

      t.string :phone
      t.string :mobile

      t.string :contact_preference, default: 'email'
      t.text   :contact_availability

      t.boolean :active, default: true

      # Omniauthenticable
      t.string :provider
      t.string :uid
      t.string :name

      # Database authenticatable
      t.string :username,           null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.timestamps
    end

    add_index :job_providers, :email,                unique: true
    add_index :job_providers, :username,             unique: true
    add_index :job_providers, :reset_password_token, unique: true
    add_index :job_providers, :confirmation_token,   unique: true
  end
end
