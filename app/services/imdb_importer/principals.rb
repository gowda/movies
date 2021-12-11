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

    def before_call
      super
      ActiveRecord::Base.connection.remove_index :principals, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :principals, :artist_imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        Principal.insert_all!(rows.map(&:to_h))
      end
    end

    def after_call
      super
      ActiveRecord::Base.connection.add_index :principals, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :principals, :artist_imdb_id, if_not_exists: true
    end
  end
end
