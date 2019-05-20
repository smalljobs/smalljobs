class AddPostponedToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :postponed, :datetime
  end
end
