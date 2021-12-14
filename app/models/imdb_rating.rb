# frozen_string_literal: true

class IMDbRating < ApplicationRecord
  belongs_to :title, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :rating

  after_save :update_parent_rating

  private

  def update_parent_rating
    title.update!(imdb_rating: average_rating)
  end
end
