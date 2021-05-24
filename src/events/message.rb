require_relative "../app/app"

module StoneFree
  module Events
    def message
      $client.message(start_with: $client.config[:prefix]) do |event|
        args = event.content.slice($client.config[:prefix].size, event.content.size).split(" ")
        next unless event.content.start_with?($client.config[:prefix])
        name = args.shift
        if StoneFree::Utils::get_command(name, { :boolean => true })
          command = StoneFree::Utils::get_command(name)

          begin
            matched_errors = []
            verified = Utils::verify_command_permission(event, command.props)

            unless verified[:user].empty?
              matched_errors << :user_permissions
            end

            unless verified[:client].empty?
              matched_errors << :client_permissions
            end

            if matched_errors.empty?
              command.run.call(event, { :args => args })
            else
              matchs = {
                :client_permissions => "• Il me manque l#{verified[:client].size > 1 ? "es" : "a"} permission#{verified[:client].size > 1 ? "es" : "a"} suivante#{verified[:client].size > 1 ? "s" : ""} : #{verified[:client].map { |perm| Utils::display(perm.to_s) }.join(", ")}",
                :user_permissions => "• Il vous manque l#{verified[:user].size > 1 ? "es" : "a"} permission#{verified[:user].size > 1 ? "es" : "a"} suivante#{verified[:user].size > 1 ? "s" : ""} : #{verified[:user].map { |perm| Utils::display(perm.to_s) }.join(", ")}"
              }
              event.channel.send_embed do |embed|
                embed.description = [
                  "**Liste des problèmes (#{matched_errors.size})**",
                  matched_errors.map { |match| matchs[match] }.join("\n")
                ].join("\n")
              end
            end
          rescue => e
            CONSOLE_LOGGER.error("Error running #{command.name}: #{e.message}")
            FILE_LOGGER.write(e.message, :errors)
          else
              CONSOLE_LOGGER.info("Command #{command.name} executed")
          end
        end
      end
    end
    module_function :message
  end
end