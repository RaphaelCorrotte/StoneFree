require_relative "../../app/app"

module StoneFree
  module Commands
    def test
      StoneFree::Command.new({ :name => :test }) do |event, tools|
        p event.message.mentions
        p event.server.users.filter { |usr| usr.id == event.message.mentions.first.id }.first
      end
    end
    module_function :test
  end
end