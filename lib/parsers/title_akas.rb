# frozen_string_literal: true

require 'csv'
require_relative 'base'

module Parsers
  class TitleAkas < Base
    KEY_MAPPING = {
      'titleId' => 'imdb_id',
      'title' => 'name',
      'types' => 'release_types',
      'attributes' => 'imdb_attributes',
      'originalTitle' => 'original_name',
      'isOriginalTitle' => 'original'
    }.freeze

    def before_call
      ActiveRecord::Base.connection.remove_index :alternate_titles, :imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        AlternateTitle.insert_all!(rows.map(&:to_h))
      end
    end

    def after_call
      ActiveRecord::Base.connection.add_index :alternate_titles, :imdb_id, if_not_exists: true
    end

    def name
      'title.akas'
    end

    def header_converters
      lambda do |h|
        (KEY_MAPPING[h].presence || h).underscore
      end
    end
  end
end
