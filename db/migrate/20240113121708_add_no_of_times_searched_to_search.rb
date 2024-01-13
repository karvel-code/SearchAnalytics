class AddNoOfTimesSearchedToSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :no_of_times_searched, :integer, null: false, default: 0
  end
end
