# NginxConfigMaker

Generate Nginx conguration using Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'nginx_config_maker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nginx_config_maker

## Usage

To generate upstream configuration like this:

```
upstream app_123 {
  server 127.0.0.1:12380;
  server api.example.com;
  server api2.example.com:1234 fail_timeout=60 max_fails=3;
  server unix:/tmp/api3.sock;
}
```

do:

```ruby
upstream = NginxConfigMaker::Upstream.new(
  name: "app_123",
  instances: [
    {host: "127.0.0.1",port:12380},
    {host: "api.example.com"},
    {host: "api2.example.com", port:1234, fail_timeout:60, max_fails:3}
    {host: "unix:/tmp/api3.sock"}
  ]
)
upstream.to_s
```

To generate server configuration like this:

```ruby
server {
  listen      [::]:80;
  listen      80;
  server_name app_123;
  location    / {
    proxy_pass  http://$APP;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$remote_addr;
    proxy_set_header X-Forwarded-Port \$server_port;
    proxy_set_header X-Request-Start \$msec;
  }
  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }
}
```

do:

```ruby
server = NginxConfigMaker::Server.new(
  listen: ["[::]:80", "80"],
  server_name: "app_123",
  location: [
    {
      at: "/",
      proxy: {
        pass: "http://app_123",
        http_version: "1.1",
        set_headers: {
          "Upgrade" => "\$http_upgrade",
          "Connection" => %Q("upgrade"),
          "Host" => "\$http_host",
          "X-Forwarded-Proto" => "\$scheme",
          "X-Forwarded-For" => "\$remote_addr",
          "X-Forwarded-Port" => "\$server_port",
          "X-Request-Start" => "\$msec",
        }
      }
    },
    {
      at: '^~ /assets/',
      gzip_static: 'on',
      expires: 'max',
      add_header: 'Cache-Control public'
    }
  ]
)
server.to_s
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nginx_config_maker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
