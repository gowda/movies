# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :directings, dependent: nil, foreign_key: :director_imdb_id, primary_key: :imdb_id, inverse_of: :director
  has_many :directed_titles, through: :directings, source: :title
  has_many :writings, dependent: nil, foreign_key: :writer_imdb_id, primary_key: :imdb_id, inverse_of: :writer
  has_many :written_titles, through: :writings, source: :title

  has_many :principals, dependent: nil, foreign_key: :artist_imdb_id, primary_key: :imdb_id, inverse_of: :artist
  has_many :titles, through: :principals, source: :title
end
