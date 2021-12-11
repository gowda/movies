# frozen_string_literal: true

class ConsoleDownloadReporter
  def call(payload)
    case payload[:event]
    when 'skip'
      printf "Skipping #{payload[:name]}\n"
    when 'start'
      printf "\rDownloading #{payload[:name]} to #{payload[:path]}"
    when 'progress'
      printf "\r#{' ' * 128}\rDownloading #{payload[:name]}#{dots.next.ljust(5, ' ')} #{human_readable(payload[:completed])}/#{human_readable(payload[:length])}"
    when 'complete'
      printf "\r#{' ' * 128}\rDownloaded #{payload[:name]} (#{human_readable(payload[:length])})\n"
    end

    true
  end

  def human_readable(number)
    ApplicationController.helpers.number_to_human_size(
      number,
      significant: false,
      precision: 2,
      strip_insignificant_zeros: false
    )
  end

  def dots
    @dots ||= (1..4).map { |i| '.' * i }.cycle
  end
end
