class CreatePrincipals < ActiveRecord::Migration[6.1]
  def change
    create_table :principals do |t|
      t.string :title_imdb_id
      t.string :artist_imdb_id
      t.integer :ordering
      t.string :category
      t.string :job
      t.string :characters

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
