class AddConfirmedToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :confirmed, :boolean, default: false
  end
end
