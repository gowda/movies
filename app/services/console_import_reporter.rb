# frozen_string_literal: true

class ConsoleImportReporter
  def call(payload)
    case payload[:event]
    when 'start', 'skip'
      printf "#{payload[:message]}\n"
    when 'progress'
      printf "\r#{payload[:message]}"
    when 'complete'
      printf "\r#{' ' * 80}\r#{payload[:message]}\n"
    end
  end
end
