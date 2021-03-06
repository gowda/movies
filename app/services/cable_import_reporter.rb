# frozen_string_literal: true

class CableImportReporter
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
      phase: 'import',
      event: payload[:event],
      completed: payload[:completed],
      total: payload[:total],
      message: payload[:message]
    }
  end
end
