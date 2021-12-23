# frozen_string_literal: true

require 'rails_helper'

describe TitlePresenter do
  let!(:title) { OpenStruct.new(name: 'Test name') }

  describe '#name' do
    let(:presenter) { described_class.new(title) }

    it 'returns name from title' do
      expect(presenter.name).to eql(title.name)
    end
  end

  describe '#genres' do
    let(:presenter) { described_class.new(title) }

    it 'returns genres from title' do
      expect(presenter.genres).to eql(title.genres)
    end
  end

  describe '#imdb_rating' do
    let(:presenter) { described_class.new(title) }

    it 'returns imdb_rating from title' do
      expect(presenter.imdb_rating).to eql(title.imdb_rating)
    end
  end

  describe '#imdb_num_votes' do
    let(:presenter) { described_class.new(title) }

    it 'returns imdb_num_votes from title' do
      expect(presenter.imdb_num_votes).to eql(title.imdb_num_votes)
    end
  end

  describe '#poster_uri' do
    context 'when title does not provide' do
      let(:presenter) { described_class.new(title) }

      it 'returns default poster_uri' do
        expect(presenter.poster_uri).not_to be_nil
      end
    end

    context 'title provides commons_picture_uri' do
      let(:poster_uri) { 'https://example.test/poster.png' }
      let(:wikidata) { OpenStruct.new(commons_picture_uri: poster_uri) }
      let(:title) { OpenStruct.new(name: 'Test name', wikidata: wikidata) }
      let(:presenter) { described_class.new(title) }

      it 'returns provided uri' do
        expect(presenter.poster_uri).to eql(poster_uri)
      end
    end
  end

  describe '#runtime' do
    context 'when less than 1 hour' do
      let(:title) { OpenStruct.new(name: 'Test name', runtime_minutes: 30) }
      let(:presenter) { described_class.new(title) }

      it 'returns minutes only' do
        expect(presenter.runtime).to eql('30mins')
      end
    end

    context 'when more than 1 hour' do
      let(:title) { OpenStruct.new(name: 'Test name', runtime_minutes: 90) }
      let(:presenter) { described_class.new(title) }

      it 'returns minutes only' do
        expect(presenter.runtime).to eql('1h 30mins')
      end
    end
  end

  describe '#release_year' do
    context 'when title provides only start_year' do
      let(:title) { OpenStruct.new(name: 'Test name', start_year: '1983') }
      let(:presenter) { described_class.new(title) }

      it 'returns single year' do
        expect(presenter.release_year).to eql('1983')
      end
    end

    context 'when title provides only start_year & end_year' do
      let(:title) { OpenStruct.new(name: 'Test name', start_year: '1983', end_year: '1994') }
      let(:presenter) { described_class.new(title) }

      it 'returns both' do
        expect(presenter.release_year).to eql('1983-1994')
      end
    end
  end
end
