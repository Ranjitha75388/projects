## Signoz

### Install SigNoz Using Docker Compose

1.In a directory :
```
git clone -b main https://github.com/SigNoz/signoz.git && cd signoz/deploy/
```
2.To install signoz
```
cd docker
docker compose up -d --remove-orphans
```
3.Verify the Installation
```
docker ps
```
## Collect Logs and Metrics using OpenTelemetry binary as an agent in VM

1.Downloading OpenTelemetry Collector .deb
```
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.116.0/otelcol-contrib_0.116.0_linux_amd64.deb
```
2.Installing OpenTelemetry Collector
```
sudo dpkg -i otelcol-contrib_0.116.0_linux_amd64.deb
```
3.download the standalone configuration for the otelcol binary running in the VM

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
    endpoint: "<IP of machine hosting SigNoz>:4317"       ### Added signoz ec2 -IP
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
### Systemd
1.To copy the updated config.yaml file:
```
sudo cp config.yaml /etc/otelcol-contrib/config.yaml
```
2.To restart otelcol with updated config:
```
sudo systemctl restart otelcol-contrib.service
```
3.To check the status of otelcol
```
sudo systemctl status otelcol-contrib.service
```
![image](https://github.com/user-attachments/assets/4614d151-763d-4fc9-8f45-7e1ec2794684)

## Added filelog for container log
```
receivers:
  filelog/containers:
    include: [ /var/lib/docker/containers/*/*.log ]
    start_at: beginning
    multiline:
      line_start_pattern: '^\{'
    operators:
      - type: json_parser
        id: parse-docker
        timestamp:
          parse_from: attributes.time
          layout: '%Y-%m-%dT%H:%M:%S.%LZ'
        severity:
          parse_from: attributes.level
      - type: move
        from: attributes.log
        to: body
```
## issue
![image](https://github.com/user-attachments/assets/ca62bf25-4676-4e74-b6ab-a01365f197a3)

Replace this part of config:
```
exporters:
  logging:
    verbosity: normal

With:

exporters:
  debug:
    verbosity: normal
```
## 2. No container logs running
![image](https://github.com/user-attachments/assets/d5604125-1738-42ca-a10a-f1fa6e2f2d8e)

```
nano /etc/systemd/system/otelcol-contrib.service
```
```
cat /etc/systemd/system/otelcol-contrib.service
[Unit]
Description=OpenTelemetry Collector Contrib
After=network.target

[Service]
EnvironmentFile=/etc/otelcol-contrib/otelcol-contrib.conf
ExecStart=/usr/bin/otelcol-contrib $OTELCOL_OPTIONS
KillMode=mixed
Restart=on-failure
Type=simple
User=otelcol-contrib
Group=otelcol-contrib

[Install]
WantedBy=multi-user.target
```
To root user
```
[Unit]
Description=OpenTelemetry Collector Contrib
After=network.target

[Service]
EnvironmentFile=/etc/otelcol-contrib/otelcol-contrib.conf
ExecStart=/usr/bin/otelcol-contrib $OTELCOL_OPTIONS
KillMode=mixed
Restart=on-failure
Type=simple
User=root
Group=root

[Install]
WantedBy=multi-user.target
```
![image](https://github.com/user-attachments/assets/74c2a5a2-fa16-4ea4-8c09-5afb3e6187ac)
