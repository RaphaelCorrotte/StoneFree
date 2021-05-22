require_relative "app/app"

cmds = StoneFree::CommandHandler.load_commands
$client.commands = []

cmds.each do |cmd|
  if StoneFree::Commands.respond_to?(cmd)
    $client.commands << StoneFree::Commands.method(cmd).call
  end
end

events = StoneFree::EventHandler.load_events

events.each do |evt|
  StoneFree::Events.method(evt).call
end

begin
  $client.run
rescue StoneFree::StoneFreeError => e
  StoneFree::CONSOLE_LOGGER.error(e.message)
end