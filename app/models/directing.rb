# frozen_string_literal: true

class Directing < ApplicationRecord
  belongs_to :title, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :directings
  belongs_to :director,
    class_name: 'Artist',
    foreign_key: :director_imdb_id,
    primary_key: :imdb_id,
    inverse_of: :directings
end
