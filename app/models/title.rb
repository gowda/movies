# frozen_string_literal: true

class Title < ApplicationRecord
  has_many :alternate_titles, dependent: nil
  has_many :directings, dependent: nil, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :title
  has_many :directors, through: :directings
  has_many :writings, dependent: nil, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :title
  has_many :writers, through: :writings
  has_many :title_episodes, dependent: nil, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: false
  has_many :episodes, through: :title_episodes, source: :episode

  has_one :parent_title,
    class_name: 'TitleEpisode',
    dependent: nil,
    foreign_key: :episode_imdb_id,
    primary_key: :imdb_id,
    inverse_of: false
  has_one :parent, class_name: 'Title', through: :parent_title, source: :title

  PRINCIPALS_OPTIONS = {
    class_name: 'Principal',
    dependent: nil,
    foreign_key: :title_imdb_id,
    primary_key: :imdb_id,
    inverse_of: :title
  }.freeze

  # NOTE: rubocop is not capable of detecting options specified in a variable value
  # rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
  has_many :principals, PRINCIPALS_OPTIONS

  has_many :principal_actors, -> { where(category: %w[actor actress]) }, PRINCIPALS_OPTIONS
  has_many :actors, through: :principal_actors, source: :artist

  has_many :principal_producers, -> { where(category: 'producer') }, PRINCIPALS_OPTIONS
  has_many :producers, through: :principal_producers, source: :artist
  # rubocop:enable Rails/HasManyOrHasOneDependent, Rails/InverseOf

  has_one :rating,
    class_name: 'IMDbRating',
    dependent: nil,
    foreign_key: :title_imdb_id,
    primary_key: :imdb_id,
    inverse_of: :title

  has_one :wikidata,
    class_name: 'TitleWikidatum',
    dependent: nil,
    foreign_key: :imdb_id,
    primary_key: :imdb_id,
    inverse_of: :title
end
