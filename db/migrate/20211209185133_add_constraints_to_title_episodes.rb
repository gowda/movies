class AddConstraintsToTitleEpisodes < ActiveRecord::Migration[6.1]
  def change
    add_index :title_episodes, :title_imdb_id, if_not_exists: true
    add_index :title_episodes, :episode_imdb_id, if_not_exists: true
    add_foreign_key :title_episodes, :titles, column: :title_imdb_id, primary_key: :imdb_id
    add_foreign_key :title_episodes, :titles, column: :episode_imdb_id, primary_key: :imdb_id
  end
end
