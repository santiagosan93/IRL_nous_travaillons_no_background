class AddProvisionalToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :provisional, :boolean, default:false
  end
end
