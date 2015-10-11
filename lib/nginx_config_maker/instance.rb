module NginxConfigMaker
  class Instance

    attr_reader :host, :port, :weight, :down, :max_fails, :fail_timeout,:slow_start

    def initialize(opts)
      @host = opts.fetch(:host)
      @port = opts[:port]
      @weight = opts[:weight]
      @down = opts[:down]
      @max_fails = opts[:max_fails]
      @fail_timeout = opts[:fail_timeout]
      @backup = opts[:backup]
    end

    def to_s
      server_address = @port ? "#{@host}:#{@port}" : @host
      config = ["  server #{server_address}"]
      config << "max_fails=#{@max_fails}" if @max_fails
      config << "weight=#{@weight}" if @weight
      config << "down" if @down
      config << "fail_timeout=#{@fail_timeout}" if @fail_timeout
      config << "slow_start=#{@slow_start}" if @slow_start
      "#{config.join(" ")};"
    end

  end
end
