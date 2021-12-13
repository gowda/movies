class AddAverageRatingIndexToIMDbRatings < ActiveRecord::Migration[6.1]
  def change
    add_index :imdb_ratings, :average_rating, if_not_exists: true
  end
end
