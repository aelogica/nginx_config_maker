require "spec_helper"

module NginxConfigMaker
  describe ProxySetHeaders do

    describe "#to_a" do
      it "converts the config to proxy_set_header options" do
        config = described_class.new(
          "Upgrade" => "yay",
          "Connection" => "upgrade",
        )

        expected_config = [
          "proxy_set_header Upgrade yay;",
          "proxy_set_header Connection upgrade;",
        ]

        expect(config.to_a).to eq expected_config
      end
    end

    describe "#to_s" do
      it "converts the option array to a string" do
        config = described_class.new(
          "Upgrade" => "yay",
          "Connection" => "upgrade",
        )

        expected_config = <<-EOQ.dedent
          proxy_set_header Upgrade yay;
          proxy_set_header Connection upgrade;
        EOQ

        expect(config.to_s).to eq expected_config
      end
    end

  end
end
