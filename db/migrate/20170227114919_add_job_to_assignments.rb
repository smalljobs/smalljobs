class AddJobToAssignments < ActiveRecord::Migration
  def change
    add_reference :assignments, :job, index: true
  end
end
