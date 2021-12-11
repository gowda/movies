# frozen_string_literal: true

require 'downloader'

namespace :import do
  desc 'download title.basics.tsv.gz'
  task download_title_basics: :environment do
    Downloader.new('title.basics').call
  end

  desc 'download name.basics.tsv.gz'
  task download_name_basics: :environment do
    Downloader.new('name.basics').call
  end

  desc 'download title.akas.tsv.gz'
  task download_title_akas: :environment do
    Downloader.new('title.akas').call
  end

  desc 'download title.crew.tsv.gz'
  task download_title_crew: :environment do
    Downloader.new('title.crew').call
  end

  desc 'download title.episode.tsv.gz'
  task download_title_episode: :environment do
    Downloader.new('title.episode').call
  end

  desc 'download title.principals.tsv.gz'
  task download_title_principals: :environment do
    Downloader.new('title.principals').call
  end

  desc 'download title.ratings.tsv.gz'
  task download_title_ratings: :environment do
    Downloader.new('title.ratings').call
  end

  desc 'download all datasets'
  task download: %i[download_title_basics download_name_basics download_title_akas download_title_crew
                    download_title_episode download_title_principals download_title_ratings]

  desc 'parse and load title.basics.tsv'
  task parse_and_load_title_basics: :download_title_basics do
    IMDbImporter.import('title.basics')
  end

  desc 'parse and load name.basics.tsv'
  task parse_and_load_name_basics: :download_name_basics do
    IMDbImporter.import('name.basics')
  end

  desc 'parse and load base datasets'
  task parse_and_load_base: %i[parse_and_load_title_basics parse_and_load_name_basics]

  desc 'parse and load title.akas.tsv'
  task parse_and_load_title_akas: %i[parse_and_load_base download_title_akas] do
    IMDbImporter.import('title.akas')
  end

  desc 'parse and load title.crew.tsv'
  task parse_and_load_title_crew: %i[parse_and_load_base download_title_crew] do
    IMDbImporter.import('title.crew')
  end

  desc 'parse and load title.episode.tsv'
  task parse_and_load_title_episode: %i[parse_and_load_base download_title_episode] do
    IMDbImporter.import('title.episode')
  end

  desc 'parse and load title.principals.tsv'
  task parse_and_load_title_principals: %i[parse_and_load_base download_title_principals] do
    IMDbImporter.import('title.principals')
  end

  desc 'parse and load title.ratings.tsv'
  task parse_and_load_title_ratings: %i[parse_and_load_base download_title_ratings] do
    IMDbImporter.import('title.ratings')
  end

  desc 'parse and load additional dataset'
  task parse_and_load_additional: %i[parse_and_load_title_akas parse_and_load_title_crew parse_and_load_title_episode
                                     parse_and_load_title_principals parse_and_load_title_ratings]

  desc 'parse and load all datasets'
  task parse_and_load: %i[parse_and_load_base parse_and_load_additional]
end
