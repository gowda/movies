# frozen_string_literal: true

class Title < ApplicationRecord
  has_many :alternate_titles, dependent: nil
end
