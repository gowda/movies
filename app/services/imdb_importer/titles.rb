# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class Titles < Base
    FOREIGN_KEY_OPTIONS = {
      alternate_titles: [
        {
          target: :titles,
          column: :imdb_id,
          primary_key: :imdb_id
        }
      ],
      directings: [
        {
          target: :titles,
          column: :title_imdb_id,
          primary_key: :imdb_id
        }
      ],
      writings: [
        {
          target: :titles,
          column: :title_imdb_id,
          primary_key: :imdb_id
        }
      ],
      title_episodes: [
        {
          target: :titles,
          column: :title_imdb_id,
          primary_key: :imdb_id
        },
        {
          target: :titles,
          column: :episode_imdb_id,
          primary_key: :imdb_id
        }
      ],
      principals: [
        {
          target: :titles,
          column: :title_imdb_id,
          primary_key: :imdb_id
        }
      ],
      imdb_ratings: [
        target: :titles,
        column: :title_imdb_id,
        primary_key: :imdb_id
      ]
    }.freeze

    def name
      'title.basics'
    end

    def item_count_in_db
      @item_count_in_db ||= Title.count
    end

    def insert_rows!(rows)
      Title.insert_all!(rows.map(&:to_h))
    end

    def pre_process
      super
      remove_foreign_keys
      remove_index
    end

    def post_process
      add_index
      add_foreign_keys
      super
    end

    private

    def add_index
      ActiveRecord::Base.connection.add_index :titles, :imdb_id, unique: true, if_not_exists: true
    end

    def add_foreign_keys
      FOREIGN_KEY_OPTIONS.each_key do |table|
        add_foreign_keys_for(table)
      end
    end

    def remove_index
      ActiveRecord::Base.connection.remove_index :titles, :imdb_id
    end

    def remove_foreign_keys
      FOREIGN_KEY_OPTIONS.each_key do |table|
        remove_foreign_keys_for(table)
      end
    end

    def add_foreign_keys_for(table)
      FOREIGN_KEY_OPTIONS[table].each do |options|
        ActiveRecord::Base.connection.add_foreign_key table, options[:target], options.except(:target)
      end
    end

    def remove_foreign_keys_for(table)
      FOREIGN_KEY_OPTIONS[table].each do |options|
        ActiveRecord::Base.connection.remove_foreign_key table, options[:target], options.except(:target)
      end
    end
  end
end
