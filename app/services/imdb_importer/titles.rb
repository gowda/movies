# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class Titles < Base
    def name
      'title.basics'
    end

    def item_count_in_db
      @item_count_in_db ||= Title.count
    end

    def before_call
      super
      ActiveRecord::Base.connection.remove_foreign_key :imdb_ratings, :titles
      ActiveRecord::Base.connection.remove_foreign_key :principals, :titles
      ActiveRecord::Base.connection.remove_foreign_key :writings, :titles
      ActiveRecord::Base.connection.remove_foreign_key :directings, :titles
      ActiveRecord::Base.connection.remove_foreign_key :alternate_titles, :titles
      ActiveRecord::Base.connection.remove_foreign_key :title_episodes, :titles
      ActiveRecord::Base.connection.remove_foreign_key :title_episodes, :titles
      ActiveRecord::Base.connection.remove_index :titles, :imdb_id
    end

    def insert_rows!(rows)
      Title.insert_all!(rows.map(&:to_h))
    end

    # rubocop:disable Metrics/MethodLength
    def after_call
      super
      ActiveRecord::Base.connection.add_index :titles, :imdb_id, unique: true, if_not_exists: true
      ActiveRecord::Base.connection.add_foreign_key :alternate_titles, :titles, column: :imdb_id, primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :directings, :titles, column: :title_imdb_id, primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :writings, :titles, column: :title_imdb_id, primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :title_episodes,
        :titles,
        column: :title_imdb_id,
        primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :title_episodes,
        :titles,
        column: :episode_imdb_id,
        primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :principals, :titles, column: :title_imdb_id, primary_key: :imdb_id
      ActiveRecord::Base.connection.add_foreign_key :imdb_ratings,
        :titles,
        column: :title_imdb_id,
        primary_key: :imdb_id
    end
    # rubocop:enable Metrics/MethodLength
  end
end
