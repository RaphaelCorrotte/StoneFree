module StoneFree
  # This class is a console or a file logger
  class Logger
    attr_reader :mode
    attr_reader :targets, :file
    # Create a Logger
    # @param mode [Symbol] the mode, either :console either :file
    # @param targets [Object] the targets file to write
    def initialize(mode = :console, targets = { :errors => "src/logs/errors.txt", :logs => "src/logs/logs.txt" })
      @mode = mode
      @targets = targets if @mode == :file
    end
    def write(data, file = :logs)
      return Logger.new(:console).warn("The file logs aren't available on #{@mode} mode") if @mode != :file
      File.open(@targets[file], "a+") do |f|
        f.write("#{Time.now.strftime("%Y-%m-%d-%H:%M:%S")} - #{mode.upcase} : #{data}\n")
      end
      data
    end
    COLORS = {
      :default => "\e[38m",
      :white => "\e[39m",
      :black => "\e[30m",
      :red => "\e[31m",
      :green => "\e[32m",
      :brown => "\e[33m",
      :blue => "\e[34m",
      :magenta => "\e[35m",
      :cyan => "\e[36m",
      :gray => "\e[37m",
      :yellow => "\e[33m",
    }.freeze
    MODES = {
      :info => :cyan,
      :error => :red,
      :warn => :yellow,
      :check => :green
    }.freeze
    # Set the console to a color
    # @param color [Symbol] the color's name
    # @param message [StringIO] The message to print
    def console_color(color, message)
      "#{COLORS[color]}#{message}\e[0m"
    end

    MODES.each do |key, value|
      # Create the color's methods
      # @param message [StringIO] the message to print
      define_method(key) do |message|
        return Logger.new(:console).warn("The console logs aren't available on #{@mode} mode") if @mode != :console
        time = Time.now.strftime("%Y-%m-%d-%H:%M:%S")
        puts "[#{console_color(:magenta, time.to_s)}] - [#{console_color(value, key.to_s.upcase)}] : #{message}"
      end
    end
    private :console_color
  end
end