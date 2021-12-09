class AddIMDbIdIndexToArtists < ActiveRecord::Migration[6.1]
  def change
    add_index :artists, :imdb_id, unique: true, if_not_exists: true
  end
end
