class AddIMDbRatingColumnToTitles < ActiveRecord::Migration[6.1]
  def change
    add_column :titles, :imdb_rating, :float
    add_index :titles, :imdb_rating, if_not_exists: true
  end
end
