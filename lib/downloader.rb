# frozen_string_literal: true

class Downloader
  attr_reader :name, :reporter

  def initialize(name, **options)
    @name = name
    @reporter = options[:reporter] || ConsoleDownloadReporter.new
  end

  def call
    report_skipping && return unless download?

    report_download_start
    download
    report_download_completion

    report_unzip_start
    unzip
    report_unzip_completion

    update_dataset
  end

  def download
    Faraday.get(url) do |req|
      req.options.on_data = lambda do |chunk, received_bytes|
        File.open(path, 'a:ASCII-8BIT') do |file|
          file.write(chunk)
        end

        report_download_progress(received_bytes)
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

    reporter.call({ phase: 'download', event: 'skip', name: name })
  end

  def report_download_start
    return true if reporter.blank?

    reporter.call({ phase: 'download', event: 'start', name: name, path: path, total: length })
  end

  def report_download_progress(completed)
    return true if reporter.blank?

    reporter.call({
      phase: 'download',
      event: 'progress',
      name: name,
      path: path,
      completed: completed,
      total: length
    })
  end

  def report_download_completion
    return true if reporter.blank?

    reporter.call({ phase: 'download', event: 'complete', name: name, path: path, total: length })
  end

  def report_unzip_start
    return true if reporter.blank?

    reporter.call({ phase: 'unzip', event: 'start', name: name, path: path, total: length })
  end

  def report_unzip_completion
    return true if reporter.blank?

    reporter.call({ phase: 'unzip', event: 'complete', name: name, path: path, total: length })
  end
end
