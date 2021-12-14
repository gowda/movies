# frozen_string_literal: true

class TitlesController < ApplicationController
  def index
    @titles = TitlesQuery.new(params[:filter]).call.page(params[:page])
  end
end
