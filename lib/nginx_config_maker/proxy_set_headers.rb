module NginxConfigMaker
  class ProxySetHeaders

    attr_reader :opts

    def initialize(opts)
      @opts = opts
    end

    def to_a
      opts.map do |key, value|
        "proxy_set_header #{key} #{value};"
      end
    end

    def to_s
      to_a.join("\n")
    end

  end
end
