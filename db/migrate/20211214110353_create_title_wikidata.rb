class CreateTitleWikidata < ActiveRecord::Migration[6.1]
  def change
    create_table :title_wikidata, id: false do |t|
      t.string :id, index: { unique: true }, primary_key: true
      t.string :uri
      t.string :imdb_id, index: { unique: true }
      t.string :commons_picture_uri
      t.string :wikipedia_uri
      t.string :name

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_foreign_key :title_wikidata, :titles, column: :imdb_id, primary_key: :imdb_id
  end
end
