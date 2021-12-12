# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class Principals < Base
    def name
      'title.principals'
    end

    def item_count_in_db
      @item_count_in_db ||= Principal.count
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        Principal.insert_all!(rows.map(&:to_h))
      end
    end

    def pre_process
      super
      remove_indices
    end

    def post_process
      add_indices
      super
    end

    private

    def remove_indices
      ActiveRecord::Base.connection.remove_index :principals, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :principals, :artist_imdb_id
    rescue ArgumentError => e
      raise e unless e.message == 'No indexes found on principals with the options provided.'

      reporter.call({ event: 'failed', message: 'Failed to prepare database table for import' })
      raise e
    end

    def add_indices
      ActiveRecord::Base.connection.add_index :principals, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :principals, :artist_imdb_id, if_not_exists: true
    end
  end
end
