module NginxConfigMaker
  class Upstream

    attr_reader :name, :host, :port

    def initialize(opts)
      @name = opts.fetch(:name)
      @host = opts.fetch(:host)
      @port = opts.fetch(:port)
    end

    def to_s
      config = ["upstream #{name} {"]
      host_and_port = [host, port].join(":")
      config << "  server #{host_and_port};"
      config << "}"
      config.join("\n")
    end

  end
end
