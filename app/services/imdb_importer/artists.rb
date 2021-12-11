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

    def insert_rows!(rows)
      Artist.insert_all!(rows.map(&:to_h))
    end

    def pre_process
      super
      remove_foreign_keys
      remove_index
    end

    def post_process
      add_index
      add_foreign_keys
      super
    end

    private

    def remove_index
      ActiveRecord::Base.connection.remove_index :artists, :imdb_id
    end

    def remove_foreign_keys
      ActiveRecord::Base.connection.remove_foreign_key :principals, :artists
      ActiveRecord::Base.connection.remove_foreign_key :writings, :artists
      ActiveRecord::Base.connection.remove_foreign_key :directings, :artists
    end

    def add_index
      ActiveRecord::Base.connection.add_index :artists, :imdb_id, unique: true, if_not_exists: true
    end

    def add_foreign_keys
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
