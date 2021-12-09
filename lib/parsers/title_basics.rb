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
      ActiveRecord::Base.connection.remove_index :titles, :imdb_id
    end

    def insert_rows!(rows)
      Title.insert_all!(rows.map(&:to_h))
    end

    def after_call
      ActiveRecord::Base.connection.add_index :titles, :imdb_id, if_not_exists: true
    end

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
