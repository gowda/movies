# frozen_string_literal: true

class CableDownloadReporter
  attr_reader :id, :action

  def initialize(id, action)
    @id = id
    @action = action
  end

  def call(payload)
    ActionCable.server.broadcast(
      'admin_datasets',
      { body: transform(payload) }
    )
  end

  def transform(payload)
    {
      id: id,
      action: action,
      phase: payload[:phase],
      event: payload[:event],
      completed: payload[:completed],
      total: payload[:total]
    }
  end
end
