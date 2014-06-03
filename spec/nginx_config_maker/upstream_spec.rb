require "spec_helper"

module NginxConfigMaker
  describe Upstream, "#to_s" do

    context "given name, host, port" do
      it "returns a upstream nginx config string for the given options" do
        config = described_class.new(
          name: "app_123",
          host: "127.0.0.1",
          port: "12380",
        )

        expected_config = <<-EOQ.dedent
          upstream app_123 {
            server 127.0.0.1:12380;
          }
        EOQ

        expect(config.to_s).to eq expected_config
      end
    end

  end
end
