class CreateTitleEpisodes < ActiveRecord::Migration[6.1]
  def change
    create_table :title_episodes do |t|
      t.string :title_imdb_id
      t.string :episode_imdb_id
      t.integer :season_number
      t.integer :episode_number

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
