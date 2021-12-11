class AddOrderingColumnToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :ordering, :integer, default: 255
  end
end
