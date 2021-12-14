# frozen_string_literal: true

class TitleWikidatum < ApplicationRecord
  belongs_to :title, foreign_key: :imdb_id, primary_key: :imdb_id, inverse_of: :wikidata
end
