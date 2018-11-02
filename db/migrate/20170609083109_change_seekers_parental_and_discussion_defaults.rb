class ChangeSeekersParentalAndDiscussionDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default :seekers, :parental, false
    change_column_default :seekers, :discussion, false
  end
end
