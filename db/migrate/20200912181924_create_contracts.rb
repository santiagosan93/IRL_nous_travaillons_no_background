class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.date :expiery_date
      t.boolean :expired, default: false
      t.belongs_to :request

      t.timestamps
    end
  end
end
