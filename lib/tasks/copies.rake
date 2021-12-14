# frozen_string_literal: true

namespace :copies do
  desc 'Copy imdb ratings to titles'
  task ratings: :environment do
    ActiveRecord::Base.logger = nil
    IMDbImporter::Ratings.new(nil).post_process
  end

  desc 'Copy all'
  task all: [:ratings]
end
