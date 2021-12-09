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

  desc 'download all datasets'
  task download: :download_title_basics

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

  desc 'parse and load base datasets'
  task parse_and_load_base: :parse_and_load_title_basics

  desc 'parse and load all datasets'
  task parse_and_load: :parse_and_load_base
end
