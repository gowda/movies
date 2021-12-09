# frozen_string_literal: true

class AlternateTitle < ApplicationRecord
  belongs_to :title, foreign_key: :imdb_id, primary_key: :imdb_id, inverse_of: :alternate_titles
end
