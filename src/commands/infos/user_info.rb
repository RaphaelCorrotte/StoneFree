require_relative "../../app/app"

module StoneFree
  module Commands
    def user_info
      StoneFree::Command.new({
                             :name => :user_info,
                             :aliases => ["ui"],
                             :description => "Affiche les informations d'une personne",
                             :use_example => "Senchu",
                             :required_permissions => :default,
                             :required_bot_permissions => :default,
                             :args => ["[utilisateur]"]
                           }) do |event, tools|

        p tools
        target = Utils::get_member(message_event: event, tools: tools)

        if target == "not_found" || target == nil ||!target
          event.respond "L'utilisateur n'a pas été trouvé. Veuillez réessayer."
          next
        end

        joined_at = StoneFree::Date.new(target.joined_at.to_datetime).format(:long)
        created_at = StoneFree::Date.new(target.creation_time.to_datetime).format(:long)

        dynamic_statuts = if target.online?
                            "#{$client.config[:emojis][:online]} En ligne"
                          elsif target.idle?
                            "#{$client.config[:emojis][:idle]} Inactif"
                          elsif target.dnd?
                          "#{$client.config[:emojis][:dnd]} Ne pas déranger"
                          elsif target.offline?
                            "#{$client.config[:emojis][:offline]} Hors ligne"
                          end
        boost_time = if target.boosting?
                    "Depuis le #{Utils::display(StoneFree::Date.new(target.boosting_since.to_datetime).format(:long))}"
                  else false end

        event.channel.send_embed do |embed|
          Utils::build_embed(embed, event.message)
          Utils::add_fields(embed, [
            {
              :name => "• Identifiant",
              :value => target.id
            },
            {
              :name => "• Surnom",
              :value => target.nick || "Aucun"
            },
            {
              :name => "• Status",
              :value => dynamic_statuts
            },
            {
              :name => "• Compté créé le",
              :value => Utils::display(created_at)
            },
            {
              :name => "• A rejoint le",
              :value => Utils::display(joined_at)
            },
            {
              :name => "• Boost de serveur",
              :value => boost_time || "Non"
            },
            {
              :name => "• Rôles",
              :value => target.roles.filter { |r| r.name != "@everyone" }.map { |r| r.mention }.join(" ") || "Aucun"
            }
          ], true)
          embed.title = "Informations sur l'utilisateur #{target.username}##{target.discriminator}"
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: target.avatar_url)
        end
      end
    end
    alias :ui :user_info
    alias :userinfo :user_info
    module_function :user_info, :ui, :userinfo
  end
end


