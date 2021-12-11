# frozen_string_literal: true

class Downloader
  attr_reader :name, :reporter

  def initialize(name, **options)
    @name = name
    @reporter = options[:reporter] || ConsoleDownloadReporter.new
  end

  def call
    report_skipping && return unless download?

    report_start

    download
    unzip
    update_dataset

    report_completion
  end

  def download
    Faraday.get(url) do |req|
      req.options.on_data = lambda do |chunk, received_bytes|
        File.open(path, 'a:ASCII-8BIT') do |file|
          file.write(chunk)
        end

        report_progress(received_bytes)
      end
    end
  end

  def unzip
    `gunzip -fk #{path}`
  end

  def update_dataset
    dataset.update!(total: total_items, file_md5sum: file_md5sum)
  end

  def file_md5sum
    @file_md5sum ||= `md5sum #{dataset.path} | awk '{ print $1 }'`.split.first
  end

  def total_items
    @total_items ||= `wc -l #{dataset.path}`.split.first.to_i - 1
  end

  def length
    @length ||= head.headers['content-length'].to_i
  end

  def head
    @head ||= Faraday.head(url)
  end

  def download?
    return true unless File.exist?(path)

    false
  end

  def path
    dataset.download_path
  end

  def url
    dataset.imdb_url
  end

  def dataset
    @dataset ||= Dataset.find_by(name: name)
  end

  def report_skipping
    return true if reporter.blank?

    reporter.call({event: 'skip', name: name})
  end

  def report_start
    return true if reporter.blank?

    reporter.call({event: 'start', name: name, path: path, length: length})
  end

  def report_progress(completed)
    return true if reporter.blank?

    reporter.call({
      event: 'progress',
      name: name,
      path: path,
      completed: completed,
      length: length
    })
  end

  def report_completion
    return true if reporter.blank?

    reporter.call({event: 'complete', name: name, path: path, length: length})
  end
end
