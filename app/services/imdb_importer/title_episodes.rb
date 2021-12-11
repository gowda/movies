# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class TitleEpisodes < Base
    def name
      'title.episode'
    end

    def item_count_in_db
      @item_count_in_db ||= TitleEpisode.count
    end

    def before_call
      super
      ActiveRecord::Base.connection.remove_index :title_episodes, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :title_episodes, :episode_imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        TitleEpisode.insert_all!(rows.map(&:to_h))
      end
    end

    def after_call
      super
      ActiveRecord::Base.connection.add_index :title_episodes, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :title_episodes, :episode_imdb_id, if_not_exists: true
    end
  end
end
