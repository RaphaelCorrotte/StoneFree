require_relative "../../app/app"

module StoneFree
  module Commands
    def channel_info
      StoneFree::Command.new({
                               :name => :channel_info,
                               :aliases => %|ci channelinfo|,
                               :description => "Affiche les informations d'un salon",
                               :use_example => "général",
                               :required_permissions => :default,
                               :required_bot_permissions => :default,
                               :args => ["[salon]"]
                             }) do |event, tools|

        target = Utils::get_channel(message_event: event, tools: tools)

        if target == :not_found || target == nil ||!target
          event.respond "Le salon n'a pas été trouvé. Veuillez réessayer."
          next
        end

        dynamic_channel_types = [
          "textuel",
          "messages privés",
          "vocal",
          "groupe",
          "catégorie",
          "annonces",
          "magasin"
        ]
        creation_tme = Utils::display(StoneFree::Date.new(target.creation_time.to_datetime).format(:long))

        fields = if target.private?
                   [
                     {
                       :name => "• Type",
                       :value => Utils::display(dynamic_channel_types[target.type])
                     },
                     {
                       :name => "• Identifiant",
                       :value => target.id.to_s
                     },
                     {
                       :name => "• Sujet",
                       :value => target.topic || "Pas de topic"
                     },
                     {
                       :name => "• Date de création",
                       :value => creation_tme
                     }
                   ]
        else [
          {
            :name => "• Type",
            :value => Utils::display(dynamic_channel_types[target.type])
          },
          {
            :name => "• Identifiant",
            :value => target.id.to_s
          },
          {
            :name => "• Position",
            :value => target.position.to_s || "0"
          },
          {
            :name => "• Sujet",
            :value => target.topic || "Pas de topic"
          },
          {
            :name => "• Date de création",
            :value => creation_tme
          }
        ] end

        event.channel.send_embed do |embed|
          Utils::build_embed(embed, event.message)
          Utils::add_fields(embed, fields, true)
          embed.title = "Informations sur le salon #{target.name}"
        end
      end
    end
    alias :ci :channel_info
    alias :channelinfo :channel_info
    module_function :channel_info, :ci, :channelinfo
  end
end



