class RemoveJobSeekerNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :job_seekers, :street, true
    change_column_null :job_seekers, :zip, true
    change_column_null :job_seekers, :city, true
    change_column_null :job_seekers, :date_of_birth, true
  end
end
