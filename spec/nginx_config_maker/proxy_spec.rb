require "spec_helper"

module NginxConfigMaker
  describe Proxy do

    describe "#to_s" do
      context "given :pass" do
        it "generates proxy config with proxy_pass" do
          config = described_class.new(pass: "http://app_123")

          expected_config = <<-EOQ.dedent
          proxy_pass http://app_123;
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end

      context "given :http_version" do
        it "generates proxy config with http_version" do
          config = described_class.new(http_version: "1.1")

          expected_config = <<-EOQ.dedent
          proxy_http_version 1.1;
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end

      context "given :set_headers" do
        it "inserts the set_header* directives returned by ProxySetHeaders" do
          config = described_class.new(set_headers: {a: 1, b: 2})

          proxy_set_headers = double(
            ProxySetHeaders,
            to_a: ["proxy_set_header a 1;", "proxy_set_header b 2;"],
          )
          allow(ProxySetHeaders).to receive(:new).with(a: 1, b: 2).
            and_return(proxy_set_headers)

          expected_config = <<-EOQ.dedent
          proxy_set_header a 1;
          proxy_set_header b 2;
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end
    end

    describe "#to_a" do
      it "returns the config as an array of lines" do
        config = described_class.new(set_headers: {a: 1, b: 2})

        proxy_set_headers = double(
          ProxySetHeaders,
          to_a: ["proxy_set_header a 1;", "proxy_set_header b 2;"],
        )
        allow(ProxySetHeaders).to receive(:new).with(a: 1, b: 2).
          and_return(proxy_set_headers)

        expected_config = [
          "proxy_set_header a 1;",
          "proxy_set_header b 2;",
        ]

        expect(config.to_a).to eq expected_config
      end
    end

  end
end
