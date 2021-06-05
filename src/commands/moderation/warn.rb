# frozen_string_literal: true

require_relative "../../app/app"

module StoneFree
  module Commands
    def warn
      StoneFree::Command.new({
                               :name => :warn,
                               :aliases => %(warning),
                               :description => "Avertis un membre",
                               :use_example => "Senchu Insultes répétées",
                               :required_permissions => :kick_members,
                               :required_bot_permissions => :default,
                               :args => ["<membre> [raison]"],
                               :strict_args => true
                             }) do |event, tools|
        $db[:warns].execute <<-SQL
          CREATE TABLE IF NOT EXISTS warns(
            guild_id integer not null,
            members not null
          )
        SQL

        target = Utils.get_member(tools: { :args => [tools[:args][0]] }, message_event: event, setting: { :include_author => false })

        if target == :not_found || target.nil? || !target
          event.respond "L'utilisateur n'a pas été trouvé. Veuillez réessayer."
          next
        end

        reason = tools[:args][1, tools[:args].size]
        guild_id = event.server.id

        insert = $db[:warns].prepare("
          INSERT OR IGNORE INTO warns(guild_id, members)
          VALUES (?, ?)
        ")
        insert.bind_params(guild_id, {}.to_json)
        insert.execute

        raw = $db[:warns].prepare <<-SQL
          SELECT * FROM warns WHERE guild_id = (?)
        SQL
        raw.bind_params(guild_id)
        rs = raw.execute

        rs.each do |raw|
          data = JSON.parse(raw["members"])
          p data
          if data[target.id].nil?
            p "#{target.username} n'a pas été averti"
            data[target.id] = {
              "warns" => 0
            }
            $db[:warns].execute("INSERT OR REPLACE INTO warns(guild_id, members) VALUES (?, ?)", guild_id, data.to_json)
            break
          else
            p "#{target.username} a été averti"
          end
        end
      end
    end
    alias warning warn
    module_function :warn, :warning
  end
end
