# frozen_string_literal: true

class Title < ApplicationRecord
  has_many :alternate_titles, dependent: nil
  has_many :directings, dependent: nil, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :title
  has_many :directors, through: :directings
  has_many :writings, dependent: nil, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :title
  has_many :writers, through: :writings
end
