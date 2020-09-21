class AddManualCompletionToTodotypes < ActiveRecord::Migration[5.0]
  def change
    add_column :todotypes, :manual_completion, :boolean, default: false
  end
end
