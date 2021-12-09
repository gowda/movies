# frozen_string_literal: true

class TitleEpisode < ApplicationRecord
  belongs_to :title, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :title_episodes
  belongs_to :episode,
    class_name: 'Title',
    foreign_key: :episode_imdb_id,
    primary_key: :imdb_id,
    inverse_of: :parent_title
end
