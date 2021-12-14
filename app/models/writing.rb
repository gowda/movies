# frozen_string_literal: true

class Writing < ApplicationRecord
  belongs_to :title,
    foreign_key: :title_imdb_id,
    primary_key: :imdb_id,
    inverse_of: :writings,
    counter_cache: :writer_count

  belongs_to :writer, class_name: 'Artist', foreign_key: :writer_imdb_id, primary_key: :imdb_id, inverse_of: :writings
end
