# frozen_string_literal: true

require_relative '../imdb_dataset_parser'

module Parsers
  class Base
    SLICE_SIZE = 10_000

    def call
      before_call

      IMDbDatasetParser.new(name, path).take(SLICE_SIZE * 5).each_slice(SLICE_SIZE) do |rows|
        insert_rows!(rows)

        dataset.increment!(:completed, rows.length, touch: true)
        print_progress
      end

      after_call
      dataset.update(fetched: true)
      print_completion
    end

    def print_progress
      printf "\rCreating#{dots.next.ljust(5, ' ')} #{completed.to_s.rjust(10, ' ')}/#{total}"
    end

    def print_completion
      printf "\r#{' ' * 80}"
      printf "\rCreated #{completed} records\n"
    end

    def before_call
    end

    def after_call
    end

    def name
      raise NotImplemented, 'do not know which file to read from'
    end

    def exceptions
      []
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
