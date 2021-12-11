# frozen_string_literal: true

require 'downloader'

class DatasetCreateJob < ApplicationJob
  def perform(name)
    reporter = create_reporter(name)

    Downloader.new(name).call
    IMDbImporter.import(name, reporter)
  end

  def create_reporter(name)
    CableImportReporter.new(name, 'import')
  end
end
