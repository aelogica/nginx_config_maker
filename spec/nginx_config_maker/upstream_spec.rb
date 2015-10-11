require "spec_helper"

module NginxConfigMaker
  describe Upstream, "#to_s" do

    context "given name, host, port" do
      it "returns a upstream nginx config string for the given options" do
        config = described_class.new(
          name: "app_123",
          instances: [
            {host: "127.0.0.1",port: "12380"},
            {host: "127.0.0.1",port: "12381"},
            {host: "www.example.com"},
            {host: "app1.example.com", weight:2},
            {host: "app2.example.com", weight:2},
            {host: "app3.example.com", weight:1},
            {host: "unix:/tmp/app4.sock"}
          ]
          
        )

        expected_config = <<-EOQ.dedent
          upstream app_123 {
            server 127.0.0.1:12380;
            server 127.0.0.1:12381;
            server www.example.com;
            server app1.example.com weight=2;
            server app2.example.com weight=2;
            server app3.example.com weight=1;
            server unix:/tmp/app4.sock;
          }
        EOQ

        expect(config.to_s).to eq expected_config
      end
    end

  end
end
