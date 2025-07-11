1.signoz installed

otel agent installed

 ## Step 2: Create the config file
 ```
nano otel-collector-config.yaml
```
```
receivers:
  hostmetrics:
    collection_interval: 10s
    scrapers:
      cpu: {}
      memory: {}
      disk: {}
      filesystem: {}
      load: {}
      network: {}
      paging: {}
      processes: {}

  docker_stats:
    endpoint: "unix:///var/run/docker.sock"
    collection_interval: 10s

  filelog/system:
    include:
      - /var/log/syslog
      - /var/log/auth.log
      - /var/log/kern.log
    start_at: beginning

  filelog/containers:
    include:
      - /var/lib/docker/containers/*/*-json.log
    start_at: beginning
    operators:
      - type: json_parser
        id: parser-docker
      - type: move
        from: attributes.log
        to: body

processors:
  batch:
    send_batch_size: 1000
    timeout: 10s

  resourcedetection:
    detectors: [system, ec2]
    override: true

  resource:
    attributes:
      - key: log.source
        value: "host"
        action: insert

exporters:
  otlp:
    endpoint: "52.5.140.96:4317"
    tls:
      insecure: true

service:
  pipelines:
    metrics:
      receivers: [hostmetrics, docker_stats]
      processors: [resourcedetection, batch]
      exporters: [otlp]

    logs:
      receivers: [filelog/system, filelog/containers]
      processors: [batch, resource]
      exporters: [otlp]
```
## Step 3: Create Docker Compose File
```
nano docker-compose.yaml
```
```
version: "3.9"
services:
  otel-collector:
    image: otel/opentelemetry-collector-contrib:0.116.0
    container_name: otel-agent
    restart: always
    volumes:
      - ./otel-collector-config.yaml:/etc/otelcol-contrib/config.yaml
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "8888:8888"       # Metrics endpoint for debugging
    command: [ "--config=/etc/otelcol-contrib/config.yaml" ]
```
## Step 4: Give permissions
```
sudo usermod -aG docker $USER
sudo chmod o+r /var/log/syslog /var/log/auth.log /var/log/kern.log
```
## Step 5: Start the Agent
```
sudo systemctl restart otelcol-contrib
```


























