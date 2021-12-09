# frozen_string_literal: true

require 'csv'
require_relative 'base'

module Parsers
  class TitleBasics < Base
    KEY_MAPPING = {
      'tconst' => 'imdb_id',
      'titleType' => 'category',
      'primaryTitle' => 'name',
      'originalTitle' => 'original_name',
      'isAdult' => 'adult'
    }.freeze

    def before_call
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

    def name
      'title.basics'
    end

    def header_converters
      lambda do |h|
        (KEY_MAPPING[h].presence || h).underscore
      end
    end
  end
end
