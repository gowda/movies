# frozen_string_literal: true

require 'sparql/client'

module WikidataImporter
  class Client
    URI = 'https://query.wikidata.org/sparql'

    KEY_MAPPING = { movie: :uri }.freeze

    attr_reader :ids

    def initialize(ids)
      @ids = ids
    end

    def find_all
      results
    end

    def results
      data_as_hash.map { |obj| transform(obj) }
    end

    def transform(obj)
      obj
        .transform_values(&:to_s)
        .transform_keys { |k| KEY_MAPPING.fetch(k, k) }
        .then { |h| h.merge(id: h[:uri].split('/').last) }
    end

    def data_as_hash
      data.map(&:to_h)
    end

    def data
      @data ||= client.query(find_all_query)
    end

    def find_all_query
      <<~SPARQL
        SELECT #{select_clause} WHERE {
          VALUES ?imdb_ids {#{quoted_ids}}
          ?_movie wdt:P31 wd:Q11424 .
          ?_movie wdt:P345 ?imdb_ids .
          ?_wikipedia_uri schema:about ?_movie .
          ?_wikipedia_uri schema:isPartOf <https://en.wikipedia.org/> .
          ?_movie wdt:P18 ?_commons_picture_uris .
          ?_movie rdfs:label ?_name filter (lang(?_name) = "en") .
          ?_movie wdt:P345 ?imdb_id
        } GROUP BY #{group_clause}
      SPARQL
    end

    def quoted_ids
      ids.map { |id| "\"#{id}\"" }.join(' ')
    end

    def select_clause
      "#{distinct_clause} #{alias_clauses}"
    end

    def distinct_clause
      'DISTINCT ?imdb_id'
    end

    def alias_clauses
      %w[movie name wikipedia_uri commons_picture_uri].map do |key|
        alias_clause_for(key)
      end.join(' ')
    end

    def alias_clause_for(key)
      "(GROUP_CONCAT(?_#{key};separator=\"|\") AS ?#{key})"
    end

    def group_clause
      '?imdb_id'
    end

    private

    def client
      @client ||= SPARQL::Client.new(URI, options)
    end

    def options
      {
        method: :get,
        headers: { 'User-Agent' => 'gowda/imdb' },
        logger: Rails.logger
      }
    end
  end
end
