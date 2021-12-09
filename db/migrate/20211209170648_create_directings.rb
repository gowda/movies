class CreateDirectings < ActiveRecord::Migration[6.1]
  def change
    create_table :directings do |t|
      t.string :title_imdb_id
      t.string :director_imdb_id

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
