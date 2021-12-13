# frozen_string_literal: true

class TitlesController < ApplicationController
  def index
    @titles = Title.includes(:rating, :directors, :producers).joins(:rating)
                   .order('imdb_ratings.average_rating' => 'desc')
                   .page(params[:page])
  end
end
