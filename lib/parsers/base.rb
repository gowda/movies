# frozen_string_literal: true

require 'csv'

module Parsers
  class Base
    attr_accessor :index

    SLICE_SIZE = 10_000

    def initialize
      @index = 0
    end

    def call
      before_call

      CSV.foreach(path, options).each_slice(SLICE_SIZE) do |rows|
        insert_rows!(rows)

        self.index += rows.length
        print_progress
      end

      after_call
      print_completion
    end

    def print_progress
      printf "\rCreating#{dots.next.ljust(5, ' ')} #{index.to_s.rjust(10, ' ')}/#{count}"
    end

    def print_completion
      printf "\r#{' ' * 80}"
      printf "\rCreated #{index} records\n"
    end

    def before_call
    end

    def after_call
    end

    def name
      raise NotImplemented, 'do not know which file to read from'
    end

    def count
      @count ||= `wc -l #{path}`.split.first.to_i - 1
    end

    def path
      Rails.root.join("tmp/#{name}.tsv")
    end

    def options
      {
        col_sep: "\t",
        headers: true,
        liberal_parsing: true,
        header_converters: header_converters,
        converters: field_converters
      }
    end

    def header_converters
      ->(h) { h == 'attributes' ? 'imdb_attributes' : h.underscore }
    end

    def field_converters
      ->(v) { v != '\N' ? v : nil }
    end

    def exceptions
      []
    end

    def dots
      @dots ||= (1..4).map { |i| '.' * i }.cycle
    end
  end
end
