# frozen_string_literal: true

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
        e.add_field(name: field[:name].to_s, value: field[:value].to_s, inline: !inline.nil?)
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
    elsif StoneFree::Commands.respond_to?(command_name)
      StoneFree::Commands.method(command_name).call
    end
  end

  # Returns a displayed text
  # @param text [StringIO] The text to display
  # @return [StringIO] the displayed text
  def display(text)
    text.split(/\s+|_+/)
        .map do |word|
      if word.size <= 2
        word.upcase
      else
        "#{word[0].upcase}#{word.slice(1, word.size).downcase}"
      end
    end
        .join(" ")
  end

  def get_member(tools:, message_event:, setting: { :include_author => true })
    if tools && message_event
      if tools[:args].empty? && setting[:include_author]
        message_event.author
      elsif !message_event.message.mentions.empty?
        message_event.server.users.filter { |usr| usr.id == message_event.message.mentions.first.id }.first
      elsif !message_event.server.members.filter { |usr| usr.id == tools[:args][0].to_i }.empty?
        message_event.server.members.filter { |usr| usr.id == tools[:args][0].to_i }.first
      elsif !message_event.channel.server.members.filter { |usr| usr.username.match(/#{tools[:args].join(" ")}/) }.empty?
        message_event.server.members.filter { |usr| usr.username.match(/#{tools[:args].join(" ")}/) }.first
      else
        :not_found
      end
    else false end
  end

  def get_channel(tools:, message_event:)
    if tools && message_event
      if tools[:args].empty?
        message_event.message.channel
      elsif !message_event.message.mentions.empty?
        message_event.server.channels.filter { |chn| chn.id == message_event.message.mentions.first.id }.first
      elsif !message_event.server.channels.filter { |chn| chn.id == tools[:args][0].to_i }.empty?
        message_event.server.channels.filter { |chn| chn.id == tools[:args][0].to_i }.first
      elsif !message_event.channel.server.channels.filter { |chn| chn.name.match(/#{tools[:args].join(" ")}/) }.empty?
        message_event.server.channels.filter { |chn| chn.name.match(/#{tools[:args].join(" ")}/) }.first
      else
        "not_found"
      end
    else false end
  end

  alias is_owner? is_authorized?
  alias find_command get_command
  module_function :is_authorized?,
                  :is_owner?,
                  :build_embed,
                  :get_command,
                  :find_command,
                  :add_fields,
                  :display,
                  :get_member,
                  :get_channel
end

#   def verify_command_permission(message_event, command_props)
#     user_missing_permissions = []
#     client_missing_permissions = []
#
#     if command_props[:required_permissions]
#       command_props[:required_permissions].each do |permission|
#         unless for_permission(message_event.author, message_event.channel, permission)
#           user_missing_permissions << permission
#         end
#       end
#     end
#
#     if command_props[:required_bot_permissions]
#       command_props[:required_bot_permissions].each do |permission|
#         bot_member = get_member(tools: { :args => $client.bot_application.id.to_s.split(" ") }, message_event: message_event)
#         unless for_permission(bot_member, message_event.channel, permission)
#           client_missing_permissions << permission
#         end
#       end
#     end
#
#     {
#       :user => user_missing_permissions,
#       :client => client_missing_permissions
#     }
#   end
