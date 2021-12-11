# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class Artists < Base
    def name
      'name.basics'
    end

    def item_count_in_db
      @item_count_in_db ||= Artist.count
    end

    def before_call
      super
      ActiveRecord::Base.connection.remove_foreign_key :principals, :artists
      ActiveRecord::Base.connection.remove_foreign_key :writings, :artists
      ActiveRecord::Base.connection.remove_foreign_key :directings, :artists
      ActiveRecord::Base.connection.remove_index :artists, :imdb_id
    end

    def insert_rows!(rows)
      Artist.insert_all!(rows.map(&:to_h))
    end

    def after_call
      super
      ActiveRecord::Base.connection.add_index :artists, :imdb_id, unique: true, if_not_exists: true
      ActiveRecord::Base.connection.add_foreign_key :directings,
        :artists,
        column: :director_imdb_id,
        primary_key: :imdb_id

      ActiveRecord::Base.connection.add_foreign_key :writings, :artists, column: :writer_imdb_id, primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :principals,
        :artists,
        column: :artist_imdb_id,
        primary_key: :imdb_id
    end
  end
end
