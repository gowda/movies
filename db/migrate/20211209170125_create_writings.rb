class CreateWritings < ActiveRecord::Migration[6.1]
  def change
    create_table :writings do |t|
      t.string :title_imdb_id
      t.string :writer_imdb_id

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
