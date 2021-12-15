class AddCompoundIndexToTitles < ActiveRecord::Migration[6.1]
  def change
    add_index :titles, [:imdb_rating, :imdb_num_votes], if_not_exists: true
    add_index :titles, [:imdb_num_votes, :imdb_rating], if_not_exists: true
  end
end
