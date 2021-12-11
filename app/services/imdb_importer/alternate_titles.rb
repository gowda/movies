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

    def before_call
      super
      ActiveRecord::Base.connection.remove_index :alternate_titles, :imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        AlternateTitle.insert_all!(rows.map(&:to_h))
      end
    end

    def after_call
      super
      ActiveRecord::Base.connection.add_index :alternate_titles, :imdb_id, if_not_exists: true
    end
  end
end
