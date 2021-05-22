require_relative "app"

module StoneFree::Utils
  # If a user has admin permissions
  # @param id [Integer] The user ID
  # @return [Boolean] if user is admin or not
  def is_authorized?(id)
    $client.config[:authorized].include?(id.to_i)
  end

  # Build the embed's body
  # @param e [Discordrb::Webhooks::Embed] the embed to build
  # @return [Discordrb::Webhooks::Embed] the built embed
  def build_embed(e = Discordrb::Webhooks::Embed.new, message = nil)
    e.title = $client.bot_app.name
    e.timestamp = Time.at(Time.now.to_i)
    if message
      e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Demandé par #{message.author.name}",
                                                      icon_url: message.author.avatar_url)
    end
    e
  end

  # Add some fields to an embed
  # @param e [Discordrb::Webhooks::Embed] the embed to build
  # @param fields [Object] The fields to add
  # @param inline [Boolean] if the fields ar inlined
  # @return [Discordrb::Webhooks::Embed] the built embed
  def add_fields(e = Discordrb::Webhooks::Embed.new, fields, inline)
    if fields.respond_to?(:each)
      fields.each do |field|
        e.add_field(name: field[:name].to_s, value: field[:value].to_s, inline: (!!inline) )
        e
      end
    else false end
  end

  # Get a command by name
  # @param command_name [StringIO] the name of the command
  # @param props [Object] The props to return a command
  # @return [Method] call the method and get the command object
  def get_command(command_name, props = { :boolean => false })
    if props[:boolean]
      return true if StoneFree::Commands.respond_to?(command_name)
      return false unless StoneFree::Commands.respond_to?(command_name)
    else
      if StoneFree::Commands.respond_to?(command_name)
        StoneFree::Commands.method(command_name).call
      end
    end
  end

  # Returns a displayed text
  # @param text [StringIO] The text to display
  # @return [StringIO] the displayed text
  def display(text)
    text.split
    .map do |word|
      if word.size <= 2
        word.upcase
      else
        "#{word[0].upcase}#{word.slice(1, word.size).downcase}"
      end
    end
        .join(" ")
  end

  alias is_owner? is_authorized?
  alias find_command get_command
  module_function :is_authorized?, :is_owner?, :build_embed, :get_command, :find_command, :add_fields, :display
end