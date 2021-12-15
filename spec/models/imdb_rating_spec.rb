# frozen_string_literal: true

require 'rails_helper'

describe IMDbRating do
  let!(:title) { create(:title) }

  describe '#create' do
    it 'updates title with rating & num_votes' do
      described_class.create!(average_rating: 4.2, num_votes: 42, title: title)

      title.reload

      expect(title.imdb_rating).to eql(4.2)
      expect(title.imdb_num_votes).to eql(42)
    end
  end

  describe '#update' do
    let!(:rating) { create(:rating, average_rating: 4.2, num_votes: 42, title: title) }

    it 'updates title with rating & num_votes' do
      rating.update(average_rating: 2.4, num_votes: 24)

      title.reload

      expect(title.imdb_rating).to eql(2.4)
      expect(title.imdb_num_votes).to eql(24)
    end
  end

  describe '#save' do
    let!(:rating) { create(:rating, average_rating: 4.2, num_votes: 42, title: title) }

    it 'updates title with rating & num_votes' do
      rating.average_rating = 2.4
      rating.num_votes = 24
      rating.save!

      title.reload

      expect(title.imdb_rating).to eql(2.4)
      expect(title.imdb_num_votes).to eql(24)
    end
  end
end
