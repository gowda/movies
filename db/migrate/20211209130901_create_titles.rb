class CreateTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :titles do |t|
      t.string :imdb_id
      t.string :category
      t.string :name
      t.string :original_name
      t.boolean :adult
      t.string :start_year
      t.string :end_year
      t.integer :runtime_minutes
      t.string :genres

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
