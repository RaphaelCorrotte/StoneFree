require_relative "../../app/app"

module StoneFree
  module Commands
    def ban
      StoneFree::Command.new({
                               :name => :ban,
                               :aliases => %|b|,
                               :description => "Bannir un membre du serveur",
                               :use_example => "Senchu ",
                               :required_permissions => :ban_members,
                               :required_bot_permissions => :default,
                               :args => ["<membre> [raison]"],
                               :strict_args => true
                             }) do |event, tools|

        target = Utils::get_member(tools: { :args => [tools[:args][0]] }, message_event: event)
        reason = tools[:args][1, tools[:args].size]

        if target == :not_found || target == nil ||!target
          event.respond "L'utilisateur n'a pas été trouvé. Veuillez réessayer."
          next
        end

        begin
          event.server.ban(target, reason: reason.join(" ") || nil)
          event.respond("L'utilisateur #{target.username}##{target.discriminator} (#{target.id}) a été banni du serveur.")
        rescue
          event.respond("Il m'est impossible de bannir et utilisateur.")
        end

      end
    end
    alias :b :ban
    module_function :ban, :b
  end
end




