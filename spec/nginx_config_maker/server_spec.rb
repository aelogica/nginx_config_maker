require "spec_helper"

module NginxConfigMaker
  describe Server do

    describe "#to_s" do
      it "generates correct nginx config", integration: true do
        config = described_class.new(
          listen: 80,
          server_name: "app.com",
          location: [
            at: "/",
            proxy: {
              pass: "http://app",
              set_headers: {
                "Connection" => %Q("upgrade")
              }
            }
          ]
        )

        expected_config = <<-EOQ.dedent
          server {
            listen 80;
            server_name app.com;
            location / {
              proxy_pass http://app;
              proxy_set_header Connection "upgrade";
            }
          }
        EOQ

        expect(config.to_s).to eq expected_config
      end

      context "listening to a single port" do
        it "generates config with one listen directive" do
          config = described_class.new(listen: 80)
          expected_config = <<-EOQ.dedent
          server {
            listen 80;
          }
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end

      context "listening to multiple ports" do
        it "generates config with multiple listen directives" do
          config = described_class.new(listen: %w(80 443))
          expected_config = <<-EOQ.dedent
          server {
            listen 80;
            listen 443;
          }
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end

      context "given a server name" do
        it "generates config with server name" do
          config = described_class.new(server_name: "app.com")
          expected_config = <<-EOQ.dedent
          server {
            server_name app.com;
          }
          EOQ

          expect(config.to_s).to eq expected_config
        end
      end

      context "given a location" do
        it "generates config with a location" do
          config = described_class.new(
            location: [
              at: "/",
              proxy: {pass: "http://app"}
            ]
          )
          expected_config = <<-EOQ.dedent
          server {
            location / { }
          }
          EOQ

          location = double(Location, to_a: ["location / { }"])
          allow(Location).to receive(:new).with(hash_including(
            at: "/",
            proxy: {pass: "http://app"}
          )).and_return(location)

          expect(config.to_s).to eq expected_config
        end
      end

      context 'given multiple locations' do
        it 'generates config with multiple location blocks' do
          config = described_class.new(
            location: [
              {at: '/', proxy: {pass: 'http://app'}},
              {at: '^~ /assets/', gzip_static: 'on', expires: 'max', add_header: 'Cache-Control public'}
            ]
          )

          expected_config = <<-EOQ.dedent
          server {
            location / {
              proxy_pass http://app;
            }
            location ^~ /assets/ {
              gzip_static on;
              expires max;
              add_header Cache-Control public;
            }
          }
          EOQ

          expect(config.to_s).to eq(expected_config)
        end
      end
    end

  end
end
