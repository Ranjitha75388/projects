1.signoz installed

## Step 2otel agent installed

1.Downloading OpenTelemetry Collector .deb
```
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.116.0/otelcol-contrib_0.116.0_linux_amd64.deb
```
2.Installing OpenTelemetry Collector
```
sudo dpkg -i otelcol-contrib_0.116.0_linux_amd64.deb
```
3.Download the standalone configuration
```
wget https://raw.githubusercontent.com/SigNoz/benchmark/main/docker/standalone/config.yaml
```
4.To copy the updated config.yaml file
```
sudo cp config.yaml /etc/otelcol-contrib/config.yaml
```
5.To restart otelcol with updated config:
```
sudo systemctl restart otelcol-contrib.service
```
6.To check the status of otelcol:
```
sudo systemctl status otelcol-contrib.service
```
7.To view logs of otelcol:
```
sudo journalctl -u otelcol-contrib.service
```
```
nano nano /etc/otelcol-contrib/config.yaml
```
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu: {}
      disk: {}
      load: {}
      filesystem: {}
      memory: {}
      network: {}
      paging: {}
      process:
        mute_process_name_error: true
        mute_process_exe_error: true
        mute_process_io_error: true
      processes: {}
  prometheus:
    config:
      global:
        scrape_interval: 30s
      scrape_configs:
        - job_name: otel-collector-binary
          static_configs:
            - targets: ['localhost:8888']
processors:
  batch:
    send_batch_size: 1000
    timeout: 10s
  # Ref: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/resourcedetectionprocessor/README.md
  resourcedetection:
    detectors: [env, system] # include ec2 for AWS, gcp for GCP and azure for Azure.
    # Using OTEL_RESOURCE_ATTRIBUTES envvar, env detector adds custom labels.
    timeout: 2s
    system:
      hostname_sources: [os] # alternatively, use [dns,os] for setting FQDN as host.name and os as fallback
extensions:
  health_check: {}
  zpages: {}
exporters:
  otlp:
    endpoint: "52.5.140.96:4317"
    tls:
      insecure: true
  logging:
    # verbosity of the logging export: detailed, normal, basic
    verbosity: normal
service:
  telemetry:
    metrics:
      address: 0.0.0.0:8888
  extensions: [health_check, zpages]
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
    metrics/internal:
      receivers: [prometheus, hostmetrics]
      processors: [resourcedetection, batch]
      exporters: [otlp]
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
```

<img width="1909" height="388" alt="image" src="https://github.com/user-attachments/assets/a0665fb9-acdf-4b94-893e-e26352b1766c" />





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


























