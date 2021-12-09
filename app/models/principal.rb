# frozen_string_literal: true

class Principal < ApplicationRecord
  belongs_to :title, foreign_key: :title_imdb_id, primary_key: :imdb_id, inverse_of: :principals
  belongs_to :artist, foreign_key: :artist_imdb_id, primary_key: :imdb_id, inverse_of: :principals
end
