
require_relative "../../app/app"

module StoneFree
  module Commands
    def purge
      StoneFree::Command.new({
                               :name => :purge,
                               :aliases => %|clear|,
                               :description => "Supprime de messages du salon",
                               :use_example => "56",
                               :required_permissions => :manage_messages,
                               :required_bot_permissions => :manage_messages,
                               :args => ["<nombre>"],
                               :strict_args => true
                             }) do |event, tools|
        to_purge = []
        count = tools[:args][0].to_i
        deleted = 0
        responce = []

        if count < 250
          if count >= 100
            a, b = count.divmod(99)
            a.times do
              to_purge << 99
            end
            to_purge << b
          elsif count <= 1
            event.respond "Vous devez supprimer plus de messages."
          else
            to_purge << count
          end
        else
          event.respond "Vous essayez de supprimer trop de messages (limite: 250)."
        end

        begin
          to_purge.each do |purge|
            event.channel.prune(purge)
          end
          rescue
        end

        responce << "Les #{count.to_s} messages ont été supprimés."


        event.respond responce.join("\n")
      end
    end
    alias :clear :purge
    module_function :purge, :clear
  end
end
