require_relative "../app/app"

module StoneFree
  module Events
    def ready
      $client.ready do
        StoneFree::CONSOLE_LOGGER.info("Client login")
        $client.game = "Ruby <3"
      end
    end
    module_function :ready
  end
end
