# frozen_string_literal: true

class Dataset < ApplicationRecord
  validates :name, presence: true, allow_blank: false

  def path
    Rails.root.join("tmp/#{filename}")
  end

  def download_path
    Rails.root.join("tmp/#{zip_filename}")
  end

  def filename
    "#{name}.tsv"
  end

  def zip_filename
    "#{filename}.gz"
  end
  alias source zip_filename

  def imdb_url
    "https://datasets.imdbws.com/#{zip_filename}"
  end
end
