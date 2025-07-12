## Signoz

### Step 1:Install SigNoz Using Docker Compose in one EC2

#### 1.In a directory :
```
git clone -b main https://github.com/SigNoz/signoz.git && cd signoz/deploy/
```
#### 2.To install signoz
```
cd docker
docker compose up -d --remove-orphans
```
#### 3.Verify the Installation
```
docker ps
```
## Collect Logs and Metrics using OpenTelemetry binary as an agent in another EC2.

#### 1.Downloading OpenTelemetry Collector .deb
```
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.116.0/otelcol-contrib_0.116.0_linux_amd64.deb
```
#### 2.Installing OpenTelemetry Collector
```
sudo dpkg -i otelcol-contrib_0.116.0_linux_amd64.deb
```
#### 3.Download the standalone configuration
```
wget https://raw.githubusercontent.com/SigNoz/benchmark/main/docker/standalone/config.yaml
```
### Systemd service

#### 4.To copy the updated config.yaml file
```
sudo cp config.yaml /etc/otelcol-contrib/config.yaml
```
#### 5.To restart otelcol with updated config:
```
sudo systemctl restart otelcol-contrib.service
```
#### 6.To check the status of otelcol:
```
sudo systemctl status otelcol-contrib.service
```
#### 7.To view logs of otelcol:
```
sudo journalctl -u otelcol-contrib.service
```
### Downloaded config file looks
```
nano /etc/otelcol-contrib/config.yaml
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
#### ERROR:

<img width="1909" height="229" alt="image" src="https://github.com/user-attachments/assets/47c31436-e362-430c-b16e-d01a98a3afd8" />

#### Action

- Replace logging with debug Exporter
```
exporters:
  logging:
    verbosity: normal

To:

exporters:
  debug:
    verbosity: normal
```
- And also update all pipelines 
```
exporters: [otlp, logging]

To:

exporters: [otlp, debug]
```
#### ERROR: No log exists in Signoz UI

## Modified file to collect system logs,container logs,system metrics,docker metrics

```
receivers:
  otlp:
    protocols:
      grpc:
      http:
# Host Metrics
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu: {}
      memory: {}
      disk: {}
      filesystem: {}
      network: {}
      load: {}
      paging: {}
      process:
        mute_process_name_error: true
        mute_process_exe_error: true
        mute_process_io_error: true
      processes: {}
# Docker Metrics
  docker_stats:
    endpoint: unix:///var/run/docker.sock
    collection_interval: 30s
    metrics:
      container.cpu.utilization:
        enabled: true
      container.memory.percent:
        enabled: true
      container.network.io.usage.rx_bytes:
        enabled: true
      container.network.io.usage.tx_bytes:
        enabled: true
      container.network.io.usage.rx_dropped:
        enabled: true
      container.network.io.usage.tx_dropped:
        enabled: true
      container.memory.usage.limit:
        enabled: true
      container.memory.usage.total:
        enabled: true
      container.blockio.io_service_bytes_recursive:
        enabled: true
# Docker Logs
  filelog/docker:
    include: ["/var/lib/docker/containers/*/*.log"]
    start_at: beginning
# System Logs
  filelog/syslog:
    include: ["/var/log/syslog", "/var/log/messages"]
    start_at: beginning

processors:
  batch:

  resourcedetection:
    detectors: [env, docker, system]
    timeout: 2s
    override: false

exporters:
  otlp:
    endpoint: "52.5.140.96:4317"
    tls:
      insecure: true

service:
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]

    metrics/internal:
      receivers: [hostmetrics, docker_stats]
      processors: [resourcedetection, batch]
      exporters: [otlp]

    logs:
      receivers: [filelog/docker, filelog/syslog]
      processors: [resourcedetection, batch]
      exporters: [otlp]
```

### Error 1

### By default, while installing SigNoz, only the Hostmetric receiver is enabled.To collect Docker Metrics,
```
 docker_stats:
    endpoint: unix:///var/run/docker.sock
    collection_interval: 30s
    metrics:
      container.cpu.utilization:
        enabled: true
      container.memory.percent:
        enabled: true
      container.network.io.usage.rx_bytes:
        enabled: true
      container.network.io.usage.tx_bytes:
        enabled: true
      container.network.io.usage.rx_dropped:
        enabled: true
      container.network.io.usage.tx_dropped:
        enabled: true
      container.memory.usage.limit:
        enabled: true
      container.memory.usage.total:
        enabled: true
      container.blockio.io_service_bytes_recursive:
        enabled: true
.
.
processors:
  resourcedetection/docker:
    detectors: [env, docker]
    timeout: 2s
    override: false
.
.
service:
  pipelines:
    metrics:
      receivers: [docker_stats]
      processors: [resourcedetection/docker]
      exporters: [otlp]
```
[refer](https://signoz.io/docs/metrics-management/docker-container-metrics/)

#### ERROR:Permissions problem with accessing the Docker socket `(/var/run/docker.sock)`.

<img width="1909" height="248" alt="image" src="https://github.com/user-attachments/assets/c4af68e1-a0c2-4718-acf6-3166aa861abe" />

#### ACTION:

<img width="682" height="327" alt="image" src="https://github.com/user-attachments/assets/99019dd2-189d-40fd-8cd8-fe6a68b901f9" />

- Check Docker socket permissions
```
ls -l /var/run/docker.sock
```
<img width="550" height="45" alt="image" src="https://github.com/user-attachments/assets/20f6066a-1718-4489-9090-ad759205d02a" />

- **Option 1**: Add `otelcol-contrib` user to the `docker` group
```
sudo usermod -aG docker otelcol
```
- Then restart the machine or the collector:
```
sudo reboot
or
sudo systemctl restart otelcol-contrib

```
- **Option 2**: Run the service as `root` 
```
sudo nano /lib/systemd/system/otelcol-contrib.service
```
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
- Then:
```
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart otelcol-contrib
```
### Output In Signoz UI 

Signoz ---> Dashboard --->New panel --->Query Builder --->Metrics ---> `container_memory_usage_total` ---> Stage and Run Query

<img width="1862" height="622" alt="image" src="https://github.com/user-attachments/assets/f834c76c-d3b6-4c43-b80c-6ce07825afc9" />

### Final config file for Host Metrics,Docker container Metrics
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4326
      http:
        endpoint: 0.0.0.0:4327

# Docker container Metrics

  docker_stats:
    endpoint: unix:///var/run/docker.sock
    collection_interval: 30s
    metrics:
      container.cpu.utilization:
        enabled: true
      container.memory.percent:
        enabled: true
      container.network.io.usage.rx_bytes:
        enabled: true
      container.network.io.usage.tx_bytes:
        enabled: true

# Host Metrics

  hostmetrics:
    collection_interval: 10s
    scrapers:
      cpu:
        metrics:
          system.cpu.utilization:
            enabled: true
      memory:
        metrics:
          system.memory.utilization:
            enabled: true
      disk:
        metrics:
          system.disk.io:
            enabled: true
      filesystem: {}
      load: {}
      network:
        metrics:
          system.network.io:
            enabled: true
      paging: {}
      processes: {}

processors:
  resourcedetection:
    detectors: [system, ec2, docker, env]
    override: true
    timeout: 2s

  batch:
    send_batch_size: 1024
    timeout: 10s

exporters:
  otlp:
    endpoint: "52.5.140.96:4317"
    tls:
      insecure: true

service:
  telemetry:
    metrics:
      address: 0.0.0.0:8888

  pipelines:
    metrics:
      receivers: [otlp, hostmetrics, docker_stats]
      processors: [resourcedetection, batch]
      exporters: [otlp]

```
`Added ec2 in processor to get instance Details in signoz UI` 



## Error 2:Logs
<img width="1919" height="531" alt="image" src="https://github.com/user-attachments/assets/1b1b0cff-401c-4971-8f82-753ad451eb4b" />
## Solution:

#### Tried `sudo otelcol-contrib --config /etc/otelcol-contrib/config.yaml`

<img width="1917" height="403" alt="image" src="https://github.com/user-attachments/assets/2f1b5982-9006-4e4a-9d9e-3ae369c11a62" />

#### Tried:otlphttp/logs insted of OTLP
```
exporters:
  otlphttp/logs:  ### For Logs
    endpoint: "http://52.5.140.96:4318"
    tls:
      insecure: true
.
.
.
service:
  pipelines:
.
.
   logs:
      receivers: [filelog/docker, filelog/syslog]
      processors: [resourcedetection, batch]
      exporters: [otlphttp/logs]
```
### ERROR
<img width="1917" height="423" alt="image" src="https://github.com/user-attachments/assets/0cc87b93-775d-4f8d-be55-5d8e6fcd4961" />

                   

-------------------------------------------
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


























