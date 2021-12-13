# frozen_string_literal: true

class IMDbRating < ApplicationRecord
  belongs_to :title, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :rating
end
