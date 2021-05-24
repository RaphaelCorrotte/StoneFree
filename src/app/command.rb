module StoneFree
  # Interpret a command
  class Command
    # @!attribute run [Method] The code to tun
    # @!attribute props [Object] The command's props
    attr_reader :run
    attr_accessor :props

    # Create a command
    # @param props [Object] The command's props, for 'load_attributes' method
    # @param run [Method] The method to ru
    # @yield The command's code
    # @yieldparam event, tools The event and the tools to run the command
    # @return [Object] a hash with the props (as 'load_attributes') and the method
    def initialize(props, &run)
      @props, @run = props, run
      @props = load_attributes
      {
        :props => load_attributes,
        :run => @run
      }
    end

    # Load command's attributes
    # @return [Object] the attributes
    private def load_attributes
      Command.attr_accessor :name, :aliases, :description, :args, :use_example, :required_permissions, :required_bot_permissions, :category, :owner_only
      if @props[:name] then @name = @props[:name] end

      @props[:aliases] ||= :default
      if @props[:aliases]
        if @props[:aliases].class == Array or @props[:aliases].class == String
          @aliases = @props[:aliases]
        elsif @aliases == :default
          @aliases = []
        else
          @aliases = []
        end
      end
      if @props[:description] then @description = @props[:description].to_s end
      if @props[:args] then @args = @props[:args].to_a end
      if @props[:use_example] then @use_example = @props[:use_example] end

      if @props[:required_permissions] == :default
        @required_permissions = []
      elsif @props[:required_permissions].respond_to?(:to_a)
          @required_permissions = @props[:required_permissions].to_a
      else
        @required_permissions = []
      end

      @required_bot_permissions ||= []
      @props[:required_bot_permissions] = [] unless @props[:required_bot_permissions].class == Array
      if @props[:required_bot_permissions] == :default or !@props[:required_bot_permissions] or @props[:required_bot_permissions].empty?

        @required_bot_permissions.push(
          :add_reactions,
          :send_messages,
          :embed_links,
          :attach_files,
          :use_external_emoji
        )
      else
        if @props[:required_bot_permissions].respond_to?(:to_a)
          @required_bot_permissions = @props[:required_bot_permissions].to_a
        else @required_bot_permissions = []
        end
      end

      if @props[:category] then @category = @props[:category] else @category = :default end

      if @use_example == :default then @use_example = "#{$client.config[:prefix]}#{@name}" end
      if @required_permissions == :default then @required_permissions = [] end

      if @category == :default or !@category
        Dir.entries("src/commands/").each do |dir|
          next if dir == "." || dir == ".."
          if Dir.entries("src/commands/#{dir}").include?("#{@name}.rb")
            @category = dir.upcase
            break
          end
        end
      end

      if props[:owner_only]
        @owner_only = true
      else
        @owner_only = false
      end

      if @category.upcase.match(/OWNER|TEST/)
        @owner_only = true
      end

      Hash[
        :name => @name,
        :aliases => @aliases,
        :description => @description,
        :args => @args,
        :required_permissions => @required_permissions,
        :required_bot_permissions => @required_bot_permissions,
        :use_example => @use_example,
        :category => @category,
        :owner_only => @owner_only
      ]
    end
  end
end
