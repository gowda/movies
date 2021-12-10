# frozen_string_literal: true

class DatasetUpdateJob < ApplicationJob
  def perform(id)
    completed = 0
    length = 5_000

    loop do
      completed += rand(1..1000)
      completed = [completed, length].min

      ActionCable.server.broadcast(
        'admin_datasets',
        {
          body: {
            id: id,
            action: 'update',
            completed: completed,
            length: length
          }
        }
      )
      sleep rand(1..10)

      break if completed == length
    end
  end
end
