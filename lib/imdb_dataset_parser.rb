# frozen_string_literal: true

require 'csv'

class IMDbDatasetParser
  include Enumerable

  KEY_MAPPINGS = {
    'name.basics' => {
      'nconst' => 'imdb_id',
      'primaryName' => 'name'
    },
    'title.basics' => {
      'tconst' => 'imdb_id',
      'titleType' => 'category',
      'primaryTitle' => 'name',
      'originalTitle' => 'original_name',
      'isAdult' => 'adult'
    },
    'title.akas' => {
      'titleId' => 'imdb_id',
      'title' => 'name',
      'types' => 'release_types',
      'attributes' => 'imdb_attributes',
      'originalTitle' => 'original_name',
      'isOriginalTitle' => 'original'
    },
    'title.crew' => {},
    'title.episode' => {
      'tconst' => 'episode_imdb_id',
      'parentTconst' => 'title_imdb_id'
    },
    'title.principals' => {
      'tconst' => 'title_imdb_id',
      'nconst' => 'artist_imdb_id'
    },
    'title.ratings' => {
      'tconst' => 'title_imdb_id'
    }
  }.freeze

  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def csv_enumerator
    @csv_enumerator ||= CSV.foreach(path, options)
  end

  delegate :each, to: :csv_enumerator

  def options
    {
      col_sep: "\t",
      headers: true,
      liberal_parsing: true,
      header_converters: header_converters,
      converters: field_converters
    }
  end

  def header_converters
    ->(h) { (key_mapping[h].presence || h).underscore }
  end

  def field_converters
    ->(v) { v != '\N' ? v : nil }
  end

  def key_mapping
    KEY_MAPPINGS[name]
  end
end
