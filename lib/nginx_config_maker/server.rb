module NginxConfigMaker
  class Server

    attr_reader :listen, :server_name, :location

    def initialize(opts)
      @listen = Array(opts[:listen])
      @server_name = opts[:server_name]
      @location = opts[:location]
    end

    def to_a
      parts = []
      parts << "server {"

      listen.each do |l|
        parts << "  listen #{l};"
      end

      if server_name
        parts << "  server_name #{server_name};"
      end

      if location && location.any?
        location.each do |location_opts|
          lines = Location.new(location_opts).to_a
          parts += lines.map {|line| "  #{line}"}
        end
      end

      parts << "}"
    end

    def to_s
      to_a.join("\n")
    end

  end
end
