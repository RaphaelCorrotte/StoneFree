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
            verified_perm = {
              :user => lambda {
                missing = []
                command.required_permissions.each do |usr_p|
                  if event.author.permission?(usr_p)
                    next
                  else
                    missing << usr_p
                  end
                  missing
                end
              },
              :client => lambda {
                missing = []
                command.required_bot_permissions.each do |bot_p|
                  if event.server.bot.permission?(bot_p)
                    next
                  else
                    missing << bot_p
                  end
                end
                missing
              }
            }

            verified_perm_user = verified_perm[:user].call
            verified_perm_bot = verified_perm[:client].call

            unless verified_perm_user.empty?
              matched_errors << :user_permissions
            end

            unless verified_perm_bot.empty?
              matched_errors << :client_permissions
            end

            if matched_errors.empty?
              command.run.call(event, { :args => args })
            else
              matchs = {
                :client_permissions => "• Il me manque l#{verified_perm_bot.size > 1 ? "es" : "a"} permission#{verified_perm_bot.size > 1 ? "es" : "a"} suivante#{verified_perm_bot.size > 1 ? "s" : ""} : #{verified_perm_bot.map { |perm| Utils::display(perm.to_s) }.join(", ")}",
                :user_permissions => "• Il vous manque l#{verified_perm_user.size > 1 ? "es" : "a"} permission#{verified_perm_user.size > 1 ? "es" : "a"} suivante#{verified_perm_user.size > 1 ? "s" : ""} : #{verified_perm_user.map { |perm| Utils::display(perm.to_s) }.join(", ")}"
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