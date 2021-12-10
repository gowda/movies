# frozen_string_literal: true

# froze_string_literal: true

module Admin
  class DatasetsController < ApplicationController
    def index
      @datasets = [
        {
          name: 'Titles',
          source: 'name.basics.tsv.gz',
          count: 0
        },
        {
          name: 'Artists',
          source: 'title.basics.tsv.gz',
          count: rand(10_000_000..40_000_000)
        },
        {
          name: 'Alternative titles',
          source: 'title.basics.tsv.gz',
          count: rand(10_000_000..40_000_000)
        },
        {
          name: 'Crew',
          source: 'title.crew.tsv.gz',
          count: rand(10_000_000..40_000_000)
        },
        {
          name: 'Episodes',
          source: 'title.episode.tsv.gz',
          count: rand(10_000_000..40_000_000)
        },
        {
          name: 'Principal cast and crew',
          source: 'title.principals.tsv.gz',
          count: rand(10_000_000..40_000_000)
        },
        {
          name: 'Ratings',
          source: 'title.ratings.tsv.gz',
          count: rand(10_000_000..40_000_000)
        }
      ].map do |h|
        OpenStruct.new(
          h.merge(
            id: h[:name].downcase.split.join('-'),
            to_partial_path: 'admin/datasets/dataset',
            updated_at: (rand(1..10).days.ago + rand(1..10).hours).to_datetime
          )
        )
      end
    end

    def create
      respond_to do |format|
        format.json do
          DatasetCreateJob.perform_later(params[:id])
          render json: { name: params[:id], status: 'queued' }, status: :created
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          DatasetUpdateJob.perform_later(params[:id])
          render json: { name: params[:id], status: 'queued' }, status: :ok
        end
      end
    end
  end
end
