require_relative "../../app/app"

module StoneFree
  module Commands
    def kick
      StoneFree::Command.new({
                               :name => :kick,
                               :aliases => %|b|,
                               :description => "Expulser un membre du serveur",
                               :use_example => "Senchu ",
                               :required_permissions => :kick_members,
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
          event.server.kick(target, reason: reason.join(" ") || nil)
          event.respond("L'utilisateur #{target.username}##{target.discriminator} (#{target.id}) a été expulsé du serveur.")
        rescue => e
          p e.message
          event.respond("Il m'est impossible d'expulser et utilisateur.")
        end

      end
    end
    alias :k :kick
    module_function :kick, :k
  end
end


