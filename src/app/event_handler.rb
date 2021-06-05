# frozen_string_literal: true

module StoneFree::EventHandler
  # Load the events
  # @return [Array] all the events
  def load_events
    events = []
    dir = Dir.entries("src/events/")
    dir.each do |file|
      next if [".", ".."].include?(file)

      load "src/events/#{file}"
      events << File.basename(file, ".rb")
    end
    StoneFree::CONSOLE_LOGGER.check("#{events.length} event#{events.length > 1 ? 's' : ''} loaded")
    events
  end
  module_function :load_events
end
