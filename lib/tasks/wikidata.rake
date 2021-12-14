# frozen_string_literal: true

namespace :wikidata do
  desc 'Import title data from wikidata'
  task import_titles: :environment do
    # ActiveRecord::Base.logger = nil

    query = IMDbRating.order('num_votes DESC NULLS LAST').order('average_rating DESC NULLS LAST')

    slice_size = 200

    query.pluck(:title_imdb_id).each_slice(slice_size).with_index do |ids, index|
      printf "\r#{' ' * 100}\rFetching...#{index * slice_size}. Completed #{(index - 1) * slice_size}"
      data = WikidataImporter.find_all(ids)

      next if data.empty?

      printf "\r#{' ' * 100}\rInserting...#{index * slice_size}. Completed #{(index - 1) * slice_size}"

      # rubocop:disable Rails/SkipsModelValidations
      TitleWikidatum.upsert_all(data)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  desc 'Copy all'
  task import: [:import_titles]
end
