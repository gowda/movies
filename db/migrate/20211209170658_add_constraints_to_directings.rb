class AddConstraintsToDirectings < ActiveRecord::Migration[6.1]
  def change
    add_index :directings, :title_imdb_id, if_not_exists: true
    add_index :directings, :director_imdb_id, if_not_exists: true
    add_foreign_key :directings, :titles, column: :title_imdb_id, primary_key: :imdb_id
    add_foreign_key :directings, :artists, column: :director_imdb_id, primary_key: :imdb_id
  end
end
