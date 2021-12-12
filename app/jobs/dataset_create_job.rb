# frozen_string_literal: true

require 'downloader'

class DatasetCreateJob < ApplicationJob
  def perform(name)
    download_reporter = create_download_reporter(name)
    Downloader.new(name, reporter: download_reporter).call

    import_reporter = create_import_reporter(name)
    IMDbImporter.import(name, import_reporter)
  end

  def create_download_reporter(name)
    CableDownloadReporter.new(name, 'import')
  end

  def create_import_reporter(name)
    CableImportReporter.new(name, 'import')
  end
end
