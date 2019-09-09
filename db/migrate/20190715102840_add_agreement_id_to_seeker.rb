class AddAgreementIdToSeeker < ActiveRecord::Migration[5.0]
  def up
    add_column :seekers, :agreement_id, :uuid
    Seeker.find_in_batches(batch_size: 500) do |seekers|
      seekers.each_with_index do |seeker, index|
        seeker.update_column(:agreement_id, SecureRandom.uuid)
      end
    end
  end

  def down
    remove_column :seekers, :agreement_id
  end

end


