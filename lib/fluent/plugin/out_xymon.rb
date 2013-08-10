
module Fluent
  class Fluent::XymonOutput < Fluent::Output
    Fluent::Plugin.register_output('xymon', self)

    def initialize
      super
    end

    config_param :xymon_server, :string
    config_param :xymon_port, :string, :default => '1984'
    config_param :color, :string, :default => 'green'
    config_param :hostname, :string
    config_param :testname, :string
    config_param :name_key, :string
    config_param :custom_determine_color_code, :string, :default => nil

    def configure(conf)
      super

      @custom_determine_color = nil
      @custom_determine_color = lambda {|time, record, value| eval(@custom_determine_color_code)} if @custom_determine_color_code
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      messages = []
      es.each {|time,record|
        next unless value = record[@name_key]

        messages.push build_message(time, record, value)
      }
      messages.each do |message|
        post(message)
      end

      chain.next
    end

    def build_message time, record, value
      begin
        color = @custom_determine_color.call(time, record, value) if @custom_determine_color
      rescue Exception
        $log.warn "raises exception: #{$!.class}, '#{$!.message}', '#{@custom_determine_color_code}', '#{time}', '#{record}', '#{value}'"
      end
      
      color ||= @color
      body = "#{@name_key}=#{value}"
      message = "status #{@hostname}.#{@testname} #{color} #{Time.at(time)} #{@testname} #{body}\n\n#{body}"

      message
    end

    def post(message)
      begin
        IO.popen("nc '#{@xymon_server}' '#{@xymon_port}'", 'w') do |io|
          io.puts message
        end
      rescue IOError, EOFError, SystemCallError
        # server didn't respond
        $log.warn "raises exception: #{$!.class}, '#{$!.message}'"
      end

      message
    end

  end
end