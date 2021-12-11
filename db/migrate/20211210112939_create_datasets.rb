class CreateDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :display_name
      t.boolean :fetched, default: false
      t.integer :completed, default: 0
      t.integer :total, default: 0

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
