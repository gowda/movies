class AddConstraintsToPrincipals < ActiveRecord::Migration[6.1]
  def change
    add_index :principals, :title_imdb_id, if_not_exists: true
    add_index :principals, :artist_imdb_id, if_not_exists: true
    add_foreign_key :principals, :titles, column: :title_imdb_id, primary_key: :imdb_id
    add_foreign_key :principals, :artists, column: :artist_imdb_id, primary_key: :imdb_id
  end
end
