# frozen_string_literal: true

require_relative "../../app/app"

module StoneFree
  module Commands
    def test
      StoneFree::Command.new({ :name => :test }) do |event, _tools|
        responds = []
        $db[:tests].results_as_hash = true
        event.respond "Test SQLite3"
        begin
          $db[:tests].execute <<-SQL
            CREATE TABLE IF NOT EXISTS test(
              id integer
            )
          SQL

          id = event.author.id

          $db[:tests].execute("INSERT OR IGNORE INTO test (id) VALUES (?)", id)

          $db[:tests].execute("SELECT * FROM test ") do |test|
            responds << test.to_s
          end

          event.respond responds.empty? ? "Aucune valeur disponible" : responds.join("\n")
        rescue StandardError => e
          event.respond "Erreur du test : #{e.class}"
          CONSOLE_LOGGER.error(e.full_message)
        end
      end
    end
    module_function :test
  end
end
