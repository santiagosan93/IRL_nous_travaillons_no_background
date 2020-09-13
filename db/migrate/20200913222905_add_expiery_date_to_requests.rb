class AddExpieryDateToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :expiery_date, :date, default: Date.today.next_month(3)
  end
end
