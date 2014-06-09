module NginxConfigMaker
  class Location

    attr_reader :at, :proxy, :gzip_static, :expires, :add_header

    def initialize(opts)
      @at = opts.fetch(:at)
      @proxy = opts[:proxy]
      @gzip_static = opts[:gzip_static]
      @expires = opts[:expires]
      @add_header = opts[:add_header]
    end

    def to_a
      parts = []
      parts << "location #{at} {"

      if proxy
        lines = Proxy.new(proxy).to_a.map
        parts += lines.map { |line| "  #{line}" }
      end

      parts << "  gzip_static #{gzip_static};" if gzip_static
      parts << "  expires #{expires};" if expires
      parts << "  add_header #{add_header};" if add_header

      parts << "}"

      parts
    end

    def to_s
      to_a.join("\n")
    end

  end
end
