# frozen_string_literal: true

require 'imdb_dataset_parser'

module IMDbImporter
  class Base
    SLICE_SIZE = 10_000

    def self.import
      new.call
    end

    def call
      print_skip_message && return unless import?

      before_process
      process
      after_process
      print_completion
    end

    def process
      IMDbDatasetParser.new(name, path).take(SLICE_SIZE * 5).each_slice(SLICE_SIZE) do |rows|
        insert_rows!(rows)

        dataset.increment!(:completed, rows.length, touch: true)
        print_progress
      end
    end

    def print_skip_message
      printf "Skipping #{dataset.filename}\n"
      true
    end

    def print_progress
      printf "\rCreating#{dots.next.ljust(5, ' ')} #{completed.to_s.rjust(10, ' ')}/#{total}"
    end

    def print_completion
      printf "\r#{' ' * 80}"
      printf "\rCreated #{completed} records\n"
    end

    def before_call
      printf "Processing #{dataset.filename}\n"
      ActiveRecord::Base.logger = nil
    end
    alias_method :before_process, :before_call

    def after_call
      dataset.update(fetched: true)
    end
    alias_method :after_process, :after_call

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
