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
end
