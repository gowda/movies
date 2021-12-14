# frozen_string_literal: true

module WikidataImporter
  def self.find_all(imdb_ids)
    Client.new(imdb_ids).find_all
  end

  def self.find(imdb_id)
    Client.new([imdb_id]).find_all.first
  end
end
