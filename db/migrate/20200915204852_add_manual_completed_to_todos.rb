class AddManualCompletedToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :manual_completion, :boolean, default: false
    add_column :todos, :completed, :datetime, default: nil
  end
end
