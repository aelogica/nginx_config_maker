module NginxConfigMaker
  class Proxy

    attr_reader :pass, :http_version, :set_headers

    def initialize(opts)
      @pass = opts[:pass]
      @http_version = opts[:http_version]
      @set_headers = opts[:set_headers]
    end

    def to_a
      parts = []
      parts << "proxy_pass #{pass};" if pass
      parts << "proxy_http_version #{http_version};" if http_version

      if set_headers
        lines = ProxySetHeaders.new(set_headers).to_a
        parts += lines
      end

      parts
    end

    def to_s
      to_a.join("\n")
    end

  end
end
