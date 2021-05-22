require_relative "app"

module StoneFree
  # A DiscordRb advanced client
  # @!attribute client [Discordrb::Bot] The client
  # @!attribute data [Object] the bot config
  class Client
    attr_reader :client
    attr_reader :data
    # Create the Client
    # @param token [StringIO] the client's token
    # Load the client's attributes
    def initialize(token)
      # Add the commands and config attributes to the discordrb bot
      Discordrb::Bot.attr_accessor :commands, :config
      @client = Discordrb::Bot.new(:token => token, :ignore_bots => true)
      @data = YAML.load(File.read("src/private/config.yml"))
      @client.config = @data
      Thread.new do
        puts "Type '.exit' to exit"
        loop do
          next unless STDIN.gets.chomp == ".exit"
          exit
        end
      end
    end
  end
end