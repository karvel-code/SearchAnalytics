class CreateAnalytics < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics do |t|
      t.integer :no_of_searches, null: false, default: 0
      t.integer :no_of_views, null: false, default: 0
      t.references :article, foreign_key: true, null: false

      t.timestamps
    end
  end
end
