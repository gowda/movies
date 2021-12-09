class AddConstraintsToIMDbRatings < ActiveRecord::Migration[6.1]
  def change
    add_index :imdb_ratings, :title_imdb_id, if_not_exists: true
    add_foreign_key :imdb_ratings, :titles, column: :title_imdb_id, primary_key: :imdb_id
  end
end
