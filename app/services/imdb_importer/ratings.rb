# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class Ratings < Base
    def name
      'title.ratings'
    end

    def item_count_in_db
      @item_count_in_db ||= IMDbRating.count
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        IMDbRating.insert_all!(rows.map(&:to_h))
      end
    end

    def pre_process
      super
      remove_index
    end

    def post_process
      super
      add_index
    end

    private

    def add_index
      ActiveRecord::Base.connection.add_index :imdb_ratings, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :imdb_ratings, :average_rating, if_not_exists: true
    end

    def remove_index
      ActiveRecord::Base.connection.remove_index :imdb_ratings, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :imdb_ratings, :average_rating
    end
  end
end
