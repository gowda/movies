# frozen_string_literal: true

namespace :counters do
  desc 'Update counters for titles'
  task update_titles: :environment do
    ActiveRecord::Base.logger = nil
    DirectorsAndWriters.new(nil).post_process
  end

  desc 'Update all counters'
  task update: [:update_titles]
end
