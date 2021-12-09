# frozen_string_literal: true

require 'csv'
require_relative 'base'

module Parsers
  class NameBasics < Base
    KEY_MAPPING = {
      'nconst' => 'imdb_id',
      'primaryName' => 'name'
    }.freeze

    def before_call
      ActiveRecord::Base.connection.remove_foreign_key :writings, :artists
      ActiveRecord::Base.connection.remove_foreign_key :directings, :artists
      ActiveRecord::Base.connection.remove_index :artists, :imdb_id
    end

    def insert_rows!(rows)
      Artist.insert_all!(rows.map(&:to_h))
    end

    def after_call
      ActiveRecord::Base.connection.add_index :artists, :imdb_id, unique: true, if_not_exists: true
      ActiveRecord::Base.connection.add_foreign_key :directings,
        :artists,
        column: :director_imdb_id,
        primary_key: :imdb_id

      ActiveRecord::Base.connection.add_foreign_key :writings, :artists, column: :writer_imdb_id, primary_key: :imdb_id
    end

    def name
      'name.basics'
    end

    def header_converters
      lambda do |h|
        (KEY_MAPPING[h].presence || h).underscore
      end
    end
  end
end
