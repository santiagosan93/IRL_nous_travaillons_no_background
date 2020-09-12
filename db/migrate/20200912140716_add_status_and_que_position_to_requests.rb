class AddStatusAndQuePositionToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :accepted, :boolean, default: false
  end
end
