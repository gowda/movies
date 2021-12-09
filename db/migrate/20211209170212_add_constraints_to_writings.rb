class AddConstraintsToWritings < ActiveRecord::Migration[6.1]
  def change
    add_index :writings, :title_imdb_id, if_not_exists: true
    add_index :writings, :writer_imdb_id, if_not_exists: true
    add_foreign_key :writings, :titles, column: :title_imdb_id, primary_key: :imdb_id
    add_foreign_key :writings, :artists, column: :writer_imdb_id, primary_key: :imdb_id
  end
end
