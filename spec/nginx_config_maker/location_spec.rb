require "spec_helper"

module NginxConfigMaker
  describe Location do

    describe "#to_s" do
      context "given proxy pass" do
        it "generates location config with proxy_pass" do
          config = described_class.new(
            at: "/",
            proxy: {
              pass: "http://app",
            }
          )

          expected_config = <<-EOQ.dedent
          location / {
            proxy_pass http://app;
          }
          EOQ

          proxy = double(to_a: ["proxy_pass http://app;"])
          allow(Proxy).to receive(:new).with(pass: "http://app") { proxy }

          expect(config.to_s).to eq expected_config
        end
      end
    end

    describe "#to_a" do
      it "returns the config in as an array of lines" do
        config = described_class.new(
          at: "/",
          proxy: {
            pass: "http://bah",
          }
        )

        expected_config = [
          "location / {",
          "  proxy_pass http://bah;",
          "}",
        ]

        proxy = double(to_a: ["proxy_pass http://bah;"])
        allow(Proxy).to receive(:new).with(pass: "http://bah") { proxy }

        expect(config.to_a).to eq expected_config
      end
    end

  end
end
