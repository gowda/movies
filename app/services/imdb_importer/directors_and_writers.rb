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

    def insert_rows!(rows)
      ActiveRecord::Base.connection.disable_referential_integrity do
        insert_directings!(rows)
        insert_writings!(rows)
      end
    end

    def pre_process
      super
      remove_indices
    end

    def post_process
      add_indices
      update_counters
      super
    end

    private

    def add_indices
      add_directings_indices
      add_writings_indices
    end

    def remove_indices
      remove_directings_indices
      remove_writings_indices
    end

    def update_counters
      ActiveRecord::Base.connection.execute(update_director_count_counters_query)
      ActiveRecord::Base.connection.execute(update_writer_count_counters_query)
    end

    def update_director_count_counters_query
      update_count_counters_query_for('director', 'directings')
    end

    def update_writer_count_counters_query
      update_count_counters_query_for('writer', 'writings')
    end

    def update_count_counters_query_for(key, table)
      <<~SQL
        INSERT INTO titles (imdb_id, #{key}_count)
          (select title_imdb_id, count(id) from #{table} group by title_imdb_id)
          ON CONFLICT(imdb_id) DO UPDATE SET #{key}_count = EXCLUDED.#{key}_count;
      SQL
    end

    def add_directings_indices
      ActiveRecord::Base.connection.add_index :directings, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :directings, :director_imdb_id, if_not_exists: true
    end

    def add_writings_indices
      ActiveRecord::Base.connection.add_index :writings, :title_imdb_id, if_not_exists: true
      ActiveRecord::Base.connection.add_index :writings, :writer_imdb_id, if_not_exists: true
    end

    def remove_directings_indices
      ActiveRecord::Base.connection.remove_index :directings, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :directings, :director_imdb_id
    end

    def remove_writings_indices
      ActiveRecord::Base.connection.remove_index :writings, :title_imdb_id
      ActiveRecord::Base.connection.remove_index :writings, :writer_imdb_id
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
  end
end
