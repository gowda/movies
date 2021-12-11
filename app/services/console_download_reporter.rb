# frozen_string_literal: true

class ConsoleDownloadReporter
  def call(payload)
    case payload[:phase]
    when 'download'
      handle_download_report(payload)
    when 'unzip'
      handle_unzip_report(payload)
    end

    true
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def handle_download_report(payload)
    case payload[:event]
    when 'skip'
      printf "Skipping #{payload[:name]}\n"
    when 'start'
      printf "\rDownloading #{payload[:name]} to #{payload[:path]}"
    when 'progress'
      prefix = "Downloading #{payload[:name]}#{dots.next.ljust(5, ' ')}"
      suffix = "#{human_readable(payload[:completed])}/#{human_readable(payload[:length])}"

      printf "\r#{' ' * 106}\r#{prefix} #{suffix}"
    when 'complete'
      printf "\r#{' ' * 106}\rDownloaded #{payload[:name]} (#{human_readable(payload[:length])})\n"
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def handle_unzip_report(payload)
    case payload[:event]
    when 'start'
      printf "\rUnzipping #{payload[:name]}"
    when 'complete'
      printf "\r#{' ' * 80}\rUnzipped #{payload[:name]}\n"
    end
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
