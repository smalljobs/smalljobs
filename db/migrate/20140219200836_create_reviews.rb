class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :job
      t.references :seeker

      t.integer :rating
      t.text :message

      t.timestamps
    end
  end
end
