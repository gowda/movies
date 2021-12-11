# frozen_string_literal: true

require_relative 'base'

module IMDbImporter
  class DirectorsAndWriters < Base
    def name
      'title.crew'
    end

    def import?
      true
    end

    def before_call
      super
      ActiveRecord::Base.connection.remove_index :directings, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :directings, :director_imdb_id

      ActiveRecord::Base.connection.remove_index :writings, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :writings, :writer_imdb_id
    end

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        insert_directings!(rows)
        insert_writings!(rows)
      end
    end

    def insert_directings!(rows)
      directings = rows.inject([], &directing_processor)
      Directing.insert_all!(directings)
    end

    def directing_processor
      @directing_processor ||= processor('directors')
    end

    def insert_writings!(rows)
      writings = rows.inject([], &writing_processor)
      Writing.insert_all!(writings)
    end

    def writing_processor
      @writing_processor ||= processor('writers')
    end

    def processor(key)
      lambda do |acc, row|
        acc.concat(
          (row[key] || '').split(',')
          .map(&:strip)
          .map { |id| { 'title_imdb_id' => row['tconst'], "#{key.singularize}_imdb_id" => id } }
        )
      end
    end

    def after_call
      super

      ActiveRecord::Base.connection.add_index :directings, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :directings, :director_imdb_id, if_not_exists: true

      ActiveRecord::Base.connection.add_index :writings, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :writings, :writer_imdb_id, if_not_exists: true
    end
  end
end
