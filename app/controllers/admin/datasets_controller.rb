# frozen_string_literal: true

module Admin
  class DatasetsController < ApplicationController
    def index
      @datasets = Dataset.all
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
