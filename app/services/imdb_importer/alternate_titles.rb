# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class AlternateTitles < Base
    def name
      'title.akas'
    end

    def item_count_in_db
      @item_count_in_db ||= AlternateTitle.count
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        AlternateTitle.insert_all!(rows.map(&:to_h))
      end
    end

    def pre_process
      super
      remove_index
    end

    def post_process
      add_index
      super
    end

    private

    def remove_index
      ActiveRecord::Base.connection.remove_index :alternate_titles, :imdb_id
    rescue ArgumentError => e
      raise e unless e.message == 'No indexes found on alternate_titles with the options provided.'

      reporter.call({ event: 'failed', message: 'Failed to prepare database table for import' })
      raise e
    end

    def add_index
      ActiveRecord::Base.connection.add_index :alternate_titles, :imdb_id, if_not_exists: true
    end
  end
end
