module NginxConfigMaker
  class Upstream

    attr_reader :name, :instances

    def initialize(opts)
      @name = opts.fetch(:name)
      @instances = opts.fetch(:instances).map{|inst| Instance.new(inst)}
    end

    def to_s
      config = ["upstream #{name} {"]
      config << @instances.map(&:to_s).join("\n")
      config << "}"
      config.join("\n")
    end

  end
end
