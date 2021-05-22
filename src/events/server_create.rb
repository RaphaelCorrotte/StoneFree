
require_relative "../app/app"

module StoneFree
  module Events
    def server_create
      $client.server_create do |event|
        $client.channel($client.config[:server_create_or_delete]).send_embed do |embed|
          StoneFree::Utils.build_embed(embed)
        end
      end
    end
    module_function :server_create
  end
end