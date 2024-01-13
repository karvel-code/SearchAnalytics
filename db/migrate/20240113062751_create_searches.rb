class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
