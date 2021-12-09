# frozen_string_literal: true

require 'downloader'
require 'parsers'

namespace :import do
  desc 'download title.basics.tsv.gz'
  task download_title_basics: :environment do
    downloader = Downloader.new('title.basics')

    downloader.call
    downloader.unzip
  end

  desc 'download name.basics.tsv.gz'
  task download_name_basics: :environment do
    downloader = Downloader.new('name.basics')

    downloader.call
    downloader.unzip
  end

  desc 'download title.akas.tsv.gz'
  task download_title_akas: :environment do
    downloader = Downloader.new('title.akas')

    downloader.call
    downloader.unzip
  end

  desc 'download all datasets'
  task download: %i[download_title_basics download_name_basics download_title_akas]

  desc 'parse and load title.basics.tsv'
  task parse_and_load_title_basics: :download_title_basics do
    in_file = `wc -l #{Rails.root.join('tmp/title.basics.tsv')}`.split.first.to_i - 1
    in_db = Title.count

    if in_file == in_db
      puts 'Skipping title.basics.tsv'
      next
    end

    puts 'Processing title.basics.tsv'
    ActiveRecord::Base.logger = nil
    Parsers::TitleBasics.new.call
  end

  desc 'parse and load name.basics.tsv'
  task parse_and_load_name_basics: :download_name_basics do
    in_file = `wc -l #{Rails.root.join('tmp/name.basics.tsv')}`.split.first.to_i - 1
    in_db = Artist.count

    if in_file == in_db
      puts 'Skipping name.basics.tsv'
      next
    end

    puts 'Processing name.basics.tsv'
    ActiveRecord::Base.logger = nil
    Parsers::NameBasics.new.call
  end

  desc 'parse and load base datasets'
  task parse_and_load_base: %i[parse_and_load_title_basics parse_and_load_name_basics]

  desc 'parse and load title.akas.tsv'
  task parse_and_load_title_akas: %i[parse_and_load_base download_title_akas] do
    in_file = `wc -l #{Rails.root.join('tmp/title.akas.tsv')}`.split.first.to_i - 1
    in_db = AlternateTitle.count

    if in_file == in_db
      puts 'Skipping title.akas.tsv'
      next
    end

    puts 'Processing title.akas.tsv'
    ActiveRecord::Base.logger = nil
    Parsers::TitleAkas.new.call
  end

  desc 'parse and load additional dataset'
  task parse_and_load_additional: :parse_and_load_title_akas

  desc 'parse and load all datasets'
  task parse_and_load: %i[parse_and_load_base parse_and_load_additional]
end
