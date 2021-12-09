# frozen_string_literal: true

require 'csv'
require_relative 'base'

module Parsers
  class TitleRatings < Base
    KEY_MAPPING = { 'tconst' => 'title_imdb_id' }.freeze

    def before_call
      ActiveRecord::Base.connection.remove_index :imdb_ratings, :title_imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        IMDbRating.insert_all!(rows.map(&:to_h))
      end
    end

    def after_call
      ActiveRecord::Base.connection.add_index :imdb_ratings, :title_imdb_id, if_not_exists: true
    end

    def name
      'title.ratings'
    end

    def header_converters
      lambda do |h|
        (KEY_MAPPING[h].presence || h).underscore
      end
    end
  end
end
