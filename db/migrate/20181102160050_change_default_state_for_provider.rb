class ChangeDefaultStateForProvider < ActiveRecord::Migration[5.0]
  def change
    change_column_default :providers, :state, 1
  end
end
