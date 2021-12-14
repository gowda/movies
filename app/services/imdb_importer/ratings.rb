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
      copy_rating_to_titles
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

    def copy_rating_to_titles
      ActiveRecord::Base.connection.remove_index :titles, :imdb_rating
      ActiveRecord::Base.connection.execute(copy_rating_to_titles_query)
      ActiveRecord::Base.connection.add_index :titles, :imdb_rating, if_not_exists: true
    end

    def copy_rating_to_titles_query
      <<~SQL
        INSERT INTO titles (imdb_id, imdb_rating)
          (select title_imdb_id, average_rating from imdb_ratings)
          ON CONFLICT(imdb_id) DO UPDATE SET imdb_rating = EXCLUDED.imdb_rating;
      SQL
    end
  end
end
