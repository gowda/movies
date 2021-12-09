class AddIMDbIdIndexToAlternateTitles < ActiveRecord::Migration[6.1]
  def change
    add_index :alternate_titles, :imdb_id, if_not_exists: true
  end
end
