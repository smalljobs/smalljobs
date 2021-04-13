class AddRcEmailToSeeker < ActiveRecord::Migration[5.0]
  def up
    add_column :seekers, :rc_email, :string
    Seeker.find_each do |seeker|
      if seeker.email.present?
        seeker.update_column(:rc_email, seeker.email)
      else
        seeker.update_column(:rc_email, "#{SecureRandom.uuid}@smalljobs.ch")
      end
    end
  end

  def down
    remove_column :seekers, :rc_email, :string
  end
end
