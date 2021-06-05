# frozen_string_literal: true

require_relative "../../app/app"

module StoneFree
  module Commands
    def serveur_info
      StoneFree::Command.new({
                               :name => :serveur_info,
                               :aliases => ["si"],
                               :description => "Affiche les informations du serveur",
                               :use_example => :default,
                               :required_permissions => :default,
                               :required_bot_permissions => :default
                             }) do |event|
        server = event.channel.server
        dynamic_verification_levels = {
          :none => "Aucun - Aucune restriction",
          :low => "Faible - Email vérifié requis",
          :medium => "Médium - Inscrit sur Discord depuis au moins 5 minutes",
          :high => "Haut - Membre du serveur depuis 10 minutes",
          :very_high => "(ʘ言ʘ╬) - Numéro de téléphone vérifié"
        }
        created_at = StoneFree::Date.new(server.creation_time.to_datetime).format(:long)

        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(embed, [
                             {
                               :name => "• **Général**",
                               :value => [
                                 "• Nom : #{server.name}",
                                 "• Créateur : #{server.owner.username}##{server.owner.discriminator}",
                                 "• Date de création : #{Utils.display(created_at)}",
                                 "• Région : #{Utils.display(server.region.name)}",
                                 "• Boosts de serveur : #{server.booster_count} (niveau #{server.boost_level})",
                                 "• Niveau de vérification : #{dynamic_verification_levels[server.verification_level]}"
                               ].join("\n")
                             },
                             {
                               :name => "• **Statistiques**",
                               :value => [
                                 "• Humains : #{server.members.select(&!:bot_account).size}",
                                 "• Robots : #{server.members.select(&:bot_account).size}",
                                 "• Salons : #{server.channels.size}",
                                 "• Emojis : #{server.emoji.size}",
                                 "• Rôles : #{server.roles.size}"
                               ].join("\n")
                             }
                           ], true)
          embed.title = "Informations sur le serveur #{server.name}"
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: server.icon_url ? server.icon_url.gsub(".webp", ".gif") : nil)
        end
      end
    end
    alias si serveur_info
    alias serveurinfo serveur_info
    module_function :serveur_info, :si, :serveurinfo
  end
end
