require_relative "app"

module StoneFree
  class Date
    MATCH_FORMAT = /YYYY|MMMM|mmmm|DDDD|dddd|YY|MM|DD|HH|mm|ss/
    MATCH_DURATION = /&t|&mm|&hh|&jj|&MM|&yy/

    attr_accessor :time, :input_type, :output_type
    attr_reader :output
    def initialize(time = DateTime.now, input_type: :date_time, output_type: :date_time)
      @input_type, @output_type = get_input_time(input_type), get_output_time(output_type)
      @time = if @input_type == :date
                if time.class == Date
                  time
                else
                  CONSOLE_LOGGER.warn("Your date isn't a date, program change to the current date")
                  Date.now
                end
              elsif @input_type == :date_time
                if time.class == DateTime
                  time
                else
                  CONSOLE_LOGGER.warn("Your DateTime isn't a DateTime, program change to the current date")
                  DateTime.now
                end
              elsif @input_type == :timestamp
                if time.class == Integer
                  Time.at(time)
                else
                  CONSOLE_LOGGER.warn("Your timestamp isn't a timestamp, program change to the current date")
                  DateTime.now
                end
              else
                CONSOLE_LOGGER.warn("Program change to the current date")
                DateTime.now
              end
    end

    def format(format_string, language = :fr)
      begin
      load "src/date_formats/#{language}.rb"
      rescue
        CONSOLE_LOGGER.warn("No file able to load")
      end
      return CONSOLE_LOGGER.warn("No method found for #{language} in #{File.path(Pathname.new("./src/date_formats/#{language}.rb"))}") unless StoneFree::Locales.respond_to?(language.to_s)
      language_attributes = StoneFree::Locales.method(language.to_s).call
      matches = {
        :YYYY => @time.year,
        :YY => (@time.year).to_s.slice(0, 2),
        :MM => @time.month,
        :MMMM => language_attributes[:months][@time.month - 1],
        :mmmm => language_attributes[:short_months][@time.month - 1],
        :DD => language_attributes[:ordinal].call(@time.day),
        :DDDD => language_attributes[:days][@time.wday - 1],
        :dddd => language_attributes[:short_days][@time.wday - 1],
        :HH => if @time.hour and @time.hour.to_s.size == 1
                 "0#{@time.hour}".to_i
               else
                 @time.hour || 0 end,
        :mm => if @time.min and @time.min.to_s.size == 1
                 "0#{@time.min}".to_i
               else
                 @time.min || 0 end,
        :ss => if @time.sec and @time.sec.to_s.size == 1
                 "0#{@time.sec}".to_i
               else
                 @time.sec || 0 end
      }
      unless MATCH_FORMAT.match(format_string)
        if language_attributes[:formats].has_key?(format_string.to_sym)
          format_string = language_attributes[:formats][:"#{format_string.to_s.downcase}"]
        else
          CONSOLE_LOGGER.warn("Bad format string #{format_string}") unless MATCH_FORMAT.match(format_string)
          return format_string
        end
      end
      format_string.gsub!(MATCH_FORMAT) do |match|
        matches[:"#{match}"] ? matches[:"#{match}"] : false
      end

      matches[:stringed] = format_string

      case @output_type
      when :string
        format_string
      when :array
        matches.values.to_a
      when :hash
        matches
      else
        CONSOLE_LOGGER.warn("No output type given")
      end
    end

    private
    def get_input_time(input_time) # :nodoc:
      [:date, :date_time, :timestamp].include?(input_time) ? input_time : :date
    end

    def get_output_time(output_time) # :nodoc:
      [:string, :array, :hash].include?(output_time) ? output_time : :string
    end
  end
end


# Don't built
=begin
    def duration(duration_string, language = :fr, future: true, past: false)
      puts DateTime.strptime(@time.to_s, "%s")
      _time = Time.strptime(@time.to_s, "%s").to_i
      if future and past
        return CONSOLE_LOGGER.error("The time format (future/past) must be only one")
      end
      begin
        load "src/date_formats/#{language}.rb"
      rescue
        CONSOLE_LOGGER.warn("No file able to load")
      end
      return CONSOLE_LOGGER.warn("No method found for #{language} in #{File.path(Pathname.new("./src/date_formats/#{language}.rb"))}") unless GameBox::Locales.respond_to?(language.to_s)
      language_attributes = GameBox::Locales.method(language.to_s).call
      _time
    end
=end