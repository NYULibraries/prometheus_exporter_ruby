# prometheus_exporter_ruby

Use the [prometheus_exporter](https://github.com/discourse/prometheus_exporter) from [Discourse](https://www.discourse.org/) as a way to aggregate metrics from our Ruby apps that run multiple worker processes via unicorn/passenger.

Tag names indicate the version of [prometheus_exporter](https://rubygems.org/gems/prometheus_exporter).

## Use

```bash
docker run -p9394:9394 nyulibraries/prometheus_exporter_ruby:0.4.0
```

### In docker-compose

```yaml
services:
  metrics:
    image: nyulibraries/prometheus_exporter_ruby:0.4.0
```

### In your Ruby application

```ruby
require 'prometheus_exporter/client'
@client = PrometheusExporter::Client.default(host: 'metrics')
error_counter = @client.register(:counter, 'nyulibraries_errors_total', 'A counter of errors')
error_counter.observe(1, kind: '422', querystring: request.env['QUERY_STRING'], path_info: request.env['PATH_INFO'])
```
