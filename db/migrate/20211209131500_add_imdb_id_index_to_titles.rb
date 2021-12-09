class AddImdbIdIndexToTitles < ActiveRecord::Migration[6.1]
  def change
    add_index :titles, :imdb_id, unique: true, if_not_exists: true
  end
end
