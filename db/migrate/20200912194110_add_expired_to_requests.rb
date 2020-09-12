class AddExpiredToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :expired, :boolean, default: false
  end
end
