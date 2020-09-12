class AddQueNumberToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :que_number, :integer
  end
end
