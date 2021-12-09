class CreateIMDbRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :imdb_ratings do |t|
      t.string :title_imdb_id
      t.float :average_rating
      t.integer :num_votes

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
