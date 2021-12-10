# frozen_string_literal: true

class DatasetsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'admin_datasets'
  end
end
