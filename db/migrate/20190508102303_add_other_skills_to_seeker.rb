class AddOtherSkillsToSeeker < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :other_skills, :text
  end
end
