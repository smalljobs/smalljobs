class AddNotesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :notes, :text
  end
end
