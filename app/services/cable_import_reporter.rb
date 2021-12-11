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
      {
        body: {
          id: id,
          action: action,
          event: payload[:event],
          completed: payload[:completed],
          length: payload[:total]
        }
      }
    )
  end
end
