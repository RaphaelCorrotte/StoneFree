# frozen_string_literal: true

require "discordrb"
require "sqlite3"
require "json"
require "yaml"
require_relative "bot"
require_relative "logger"
require_relative "error"
require_relative "command_handler"
require_relative "event_handler"
require_relative "command"
require_relative "utils"
require_relative "date"

module StoneFree
  include Discordrb
  include JSON
  include YAML
  CONSOLE_LOGGER = Logger.new(:console)
  FILE_LOGGER = Logger.new(:file)
end

$stone_free = StoneFree::Client.new(YAML.load_file("src/private/config.yml")[:token])
$client = $stone_free.client
$db = {}

$db[:tests] = SQLite3::Database.new("src/database/test.db")
$db[:warns] = SQLite3::Database.new("src/database/warns.db")
$db[:warns].results_as_hash = true
