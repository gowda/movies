# frozen_string_literal: true

class DatasetCreateJob < ApplicationJob
  def perform(id)
    (1..5).each do |index|
      Rails.logger.debug "Sleeping - #{index}"
      sleep 10
    end
  end
end
