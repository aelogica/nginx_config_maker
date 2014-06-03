module NginxConfigMaker
  class Location

    attr_reader :at, :proxy

    def initialize(opts)
      @at = opts.fetch(:at)
      @proxy = opts[:proxy]
    end

    def to_a
      parts = []
      parts << "location #{at} {"

      if proxy
        lines = Proxy.new(proxy).to_a.map
        parts += lines.map { |line| "  #{line}" }
      end

      parts << "}"

      parts
    end

    def to_s
      to_a.join("\n")
    end

  end
end
