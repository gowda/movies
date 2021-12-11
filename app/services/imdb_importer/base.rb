# frozen_string_literal: true

require 'imdb_dataset_parser'

module IMDbImporter
  class Base
    SLICE_SIZE = 10_000

    attr_reader :reporter

    def self.import(reporter = nil)
      reporter = reporter.presence || ConsoleImportReporter.new
      new(reporter).call
    end

    def initialize(reporter)
      @reporter = reporter
    end

    def call
      report_skipping && return unless import?

      pre_process
      process
      post_process
      report_completion
    end

    def process
      IMDbDatasetParser.new(name, path).each_slice(SLICE_SIZE) do |rows|
        insert_rows!(rows)

        dataset.increment!(:completed, rows.length, touch: true)
        report_progress
      end
    end

    def report_skipping
      return true unless reporter.present?

      reporter.call({event: 'skip', message: "Skipping #{dataset.filename}\n"})
    end

    def report_start
      return true unless reporter.present?

      reporter.call({
        event: 'start',
        message: start_message,
        total: total
      })
    end

    def start_message
      "Processing #{dataset.filename}"
    end

    def report_progress
      return true unless reporter.present?

      reporter.call({
        event: 'progress',
        message: progress_message,
        completed: completed,
        total: total
      })
    end

    def progress_message
      "Importing#{dots.next.ljust(5, ' ')} #{completed.to_s.rjust(10, ' ')}/#{total}"
    end

    def report_completion
      return true unless reporter.present?

      reporter.call({
        event: 'completion',
        message: completion_message,
        completed: completed,
        total: total
      })
    end

    def completion_message
      "Created #{completed} records"
    end

    def pre_process
      report_start
      ActiveRecord::Base.logger = nil
    end

    def post_process
      dataset.update(fetched: true)
    end

    def name
      raise NotImplemented, 'do not know which file to read from'
    end

    def import?
      item_count_in_file != item_count_in_db
    end

    def item_count_in_file
      @item_count_in_file ||= `wc -l #{dataset.path}`.split.first.to_i - 1
    end

    def item_count_in_db
      raise NotImplemented, "do not know what is item count in db for #{name}"
    end

    def dataset
      @dataset ||= Dataset.find_by(name: name)
    end

    delegate :completed, to: :dataset
    delegate :total, to: :dataset
    delegate :path, to: :dataset

    def dots
      @dots ||= (1..4).map { |i| '.' * i }.cycle
    end
  end
end
