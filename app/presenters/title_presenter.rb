# frozen_string_literal: true

class TitlePresenter
  attr_reader :title

  def initialize(title)
    @title = title
  end

  delegate :name, :genres, :imdb_rating, to: :title

  def runtime
    return 'N/A' if title.runtime_minutes.blank?
    return "#{runtime_minutes}mins" if runtime_hours.zero?
    return "#{runtime_hours}h" if runtime_minutes.zero?

    "#{runtime_hours}h #{runtime_minutes}mins"
  end

  def release_year
    [title.start_year, title.end_year].compact.join('-')
  end

  def directors
    return director_names.first if director_names.length < 2
    return director_names.join(' and ') if director_names.length == 2

    "#{director_names.take(2).join(', ')} and others"
  end

  def actors
    title.actors.take(5).map(&:name).join(', ')
  end

  def producers
    title.producers.map(&:name).join(', ')
  end

  private

  def director_names
    title.directors.map(&:name)
  end

  def runtime_hours
    @runtime_hours ||= title.runtime_minutes / 60
  end

  def runtime_minutes
    @runtime_minutes ||= title.runtime_minutes % 60
  end
end
