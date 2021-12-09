class CreateAlternateTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :alternate_titles do |t|
      t.string :imdb_id
      t.integer :ordering
      t.string :name
      t.string :region
      t.string :language
      t.string :release_types
      t.string :imdb_attributes
      t.boolean :original

      # https://github.com/rails/rails/issues/35493#issuecomment-470100313
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
