class AddIMDbIdForeignKeyConstraintToAlternateTitles < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :alternate_titles, :titles, column: :imdb_id, primary_key: :imdb_id
  end
end
