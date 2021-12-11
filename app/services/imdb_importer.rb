# frozen_string_literal: true

module IMDbImporter
  require_relative 'imdb_importer/titles'
  require_relative 'imdb_importer/artists'
  require_relative 'imdb_importer/alternate_titles'
  require_relative 'imdb_importer/directors_and_writers'
  require_relative 'imdb_importer/title_episodes'
  require_relative 'imdb_importer/principals'
  require_relative 'imdb_importer/ratings'

  class << self
    IMPORTERS = {
      'title.basics' => Titles,
      'name.basics' => Artists,
      'title.akas' => AlternateTitles,
      'title.crew' => DirectorsAndWriters,
      'title.episode' => TitleEpisodes,
      'title.principals' => Principals,
      'title.ratings' => Ratings
    }

    def import(name)
      raise ArgumentError, "do not know how to import #{name}" if unknown?(name)

      IMPORTERS[name].import
    end

    def unknown?(name)
      !known?(name)
    end

    def known?(name)
      IMPORTERS.keys.include?(name)
    end
  end
end
