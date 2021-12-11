# frozen_string_literal: true

module Admin
  class DatasetsController < ApplicationController
    def index
      @datasets = Dataset.order(:ordering).all
    end

    def create
      respond_to do |format|
        format.json do
          DatasetCreateJob.perform_later(params[:name])
          render json: { name: params[:name], status: 'queued' }, status: :created
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          DatasetUpdateJob.perform_later(params[:name])
          render json: { name: params[:name], status: 'queued' }, status: :ok
        end
      end
    end
  end
end
