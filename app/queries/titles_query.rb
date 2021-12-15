# frozen_string_literal: true

class TitlesQuery
  attr_reader :filter

  FILTERS = [
    {
      name: 'movies',
      label: 'Movies'
    },
    {
      name: 'tv-series',
      label: 'TV Series'
    },
    {
      name: 'single-director',
      label: 'Single director'
    },
    {
      name: '2-directors',
      label: '2 directors'
    },
    {
      name: 'n-directors',
      label: 'Multiple directors'
    },
    {
      name: 'with-producer',
      label: 'At least one producer'
    }
  ].freeze

  def initialize(filter = nil)
    @filter = filter if filter?(filter)
  end

  def call
    titles
  end

  def titles
    @titles ||= filtered_query
  end

  # rubocop:disable Metrics/MethodLength
  def filtered_query
    case filter
    when 'movies'
      base_query.where(category: 'movies')
    when 'tv-series'
      base_query.where(category: %w[tvSeries tvMiniSeries])
    when 'single-director'
      base_query.where(director_count: 1)
    when '2-directors'
      base_query.where(director_count: 2)
    when 'n-directors'
      base_query.where('director_count >' => 2)
    else
      base_query
    end
  end
  # rubocop:enable Metrics/MethodLength

  def base_query
    Title.includes(:rating, :producers, :directors, :actors)
         .where('imdb_num_votes IS NOT NULL')
         .where('imdb_rating IS NOT NULL')
         .order('imdb_num_votes DESC')
         .order('imdb_rating DESC')
  end

  def filter?(label)
    FILTERS.map { |f| f[:name] }.include?(label)
  end
end
