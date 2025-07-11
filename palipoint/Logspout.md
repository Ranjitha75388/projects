Step-by-step Instructions
🔹 Step 1: SigNoz Server Setup (on 52.5.140.96)
1.1 Navigate to SigNoz directory
```
cd ~/signoz/deploy/docker
```
1.2 Update otel-collector-config.yaml

Replace your current file with this corrected config 👇
✅ otel-collector-config.yaml
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

  httplogreceiver/json:
    endpoint: 0.0.0.0:8082
    source: json

processors:
  batch:
  resourcedetection:
    detectors: [env, system]
    timeout: 2s

exporters:
  clickhousetraces:
    datasource: tcp://clickhouse:9000/signoz_traces
    use_new_schema: true

  clickhousemetricswrite:
    endpoint: tcp://clickhouse:9000/signoz_metrics
    resource_to_telemetry_conversion:
      enabled: true

  signozclickhousemetrics:
    dsn: tcp://clickhouse:9000/signoz_metrics

  clickhouselogsexporter:
    dsn: tcp://clickhouse:9000/signoz_logs
    timeout: 10s
    use_new_schema: true

service:
  telemetry:
    logs:
      encoding: json
    metrics:
      address: 0.0.0.0:8888

  extensions: []

  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [clickhousetraces]

    metrics:
      receivers: [otlp]
      processors: [resourcedetection, batch]
      exporters: [clickhousemetricswrite, signozclickhousemetrics]

    logs:
      receivers: [httplogreceiver/json]
      processors: [resourcedetection, batch]
      exporters: [clickhouselogsexporter]
```
1.3 Update docker-compose.yaml to expose port 8082

In ~/signoz/deploy/docker/docker-compose.yaml, make sure otel-collector service has this:
```
services:
  otel-collector:
    image: signoz/signoz-otel-collector:latest
    container_name: signoz-otel-collector
    ports:
      - "4317:4317"
      - "4318:4318"
      - "8082:8082"   # <-- add this line
    volumes:
      - ./otel-collector-config.yaml:/etc/otel-collector-config.yaml
```
1.4 Restart SigNoz stack
```
docker-compose down
docker-compose up -d
```
✅ Now your SigNoz collector is ready to receive Docker logs via HTTP JSON.
🔹 Step 2: App Server Setup (e.g., 54.208.x.x)
2.1 Ensure Docker is running

You must have your app containers running like:

docker ps

2.2 Run logspout-signoz container

Replace 52.5.140.96 with your SigNoz server public IP:
```
docker run -d \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  -e 'SIGNOZ_LOG_ENDPOINT=http://52.5.140.96:8082' \
  -e 'ENV=prod' \
  pavanputhra/logspout-signoz \
  signoz://52.5.140.96:8082
```
✅ This will automatically:

    Detect all Docker containers on this server

    Send logs to SigNoz with:

        service.name = container name

        host.name = EC2 hostname

        deployment.environment = "prod"

Optional (but recommended): Label your containers

When running your containers, you can set labels to override defaults:
```
docker run -d \
  --label signoz.dev/service.name=my-backend-service \
  my-backend-image
```
✅ Step 3: View logs in SigNoz

    Visit http://52.5.140.96:3301

    Go to Logs > Explorer

    Filter by:

        service.name

        host.name

        env (if you passed ENV=prod)

    You’ll see logs from your containers 🎉

✅ Final Notes

    You do not need OpenTelemetry agent or binary on App EC2 for logs

    This method works even if your app is not instrumented

    You can use OTEL agent on app EC2 for metrics/traces, but not required for logs

🚀 Bonus (If you want metrics too)

If you want to collect system or app metrics from App EC2, you can run:

wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/latest/download/otelcol-contrib_0.96.0_linux_amd64.tar.gz
tar -xvzf otelcol-contrib_0.96.0_linux_amd64.tar.gz
./otelcol-contrib --config=config.yaml

Where config.yaml sends metrics to http://52.5.140.96:4317.




---------------------------------------------

To get metrics from the same app server along with logs, you need to run an OpenTelemetry Collector or Agent on the app server that sends metrics to your SigNoz server. The logspout-signoz container is only for logs — it does not collect metrics.
✅ Goal

You want:

    Logs → collected via logspout-signoz ✅

    Metrics → collected via otel-collector binary or agent 🧭

✅ Final Architecture Overview

APP SERVER (Docker Host)
├── Application containers (frontend, backend, etc.)
├── logspout-signoz     ---> forwards logs to SigNoz (http://<signoz-ip>:8082)
└── otel-collector (binary or agent)
     └── collects metrics and sends to SigNoz (http://<signoz-ip>:4317)

SIGNOZ SERVER (Docker)
└── OpenTelemetry Collector (configured with receivers for logs + metrics + traces)

✅ Steps to Enable Metrics on App Server
1. Install OpenTelemetry Collector (binary) on the App Server

You can use the contrib distribution or download the binary:
```
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.102.1/otelcol-contrib_0.102.1_linux_amd64.tar.gz
tar -xvf otelcol-contrib_0.102.1_linux_amd64.tar.gz
sudo mv otelcol-contrib /usr/local/bin/
```
2. Create config.yaml for App Server Otel Agent

Create this file as /etc/otelcol-contrib/config.yaml:
```
receivers:
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu:
      memory:
      disk:
      filesystem:
      load:
      network:
      paging:
      processes:

  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:
  resourcedetection:
    detectors: [env, system]
    timeout: 2s

exporters:
  otlp:
    endpoint: <SIGNOZ_SERVER_IP>:4317
    tls:
      insecure: true

service:
  pipelines:
    metrics:
      receivers: [hostmetrics]
      processors: [resourcedetection, batch]
      exporters: [otlp]
```
Replace <SIGNOZ_SERVER_IP> with your actual SigNoz server’s IP (e.g., 52.5.140.96).
3. Run the Otel Agent

otelcol-contrib --config /etc/otelcol-contrib/config.yaml

You can also run this as a systemd service or use Docker if preferred.
✅ Result

You will now have:

    Logs: via logspout-signoz → http://<sigz-ip>:8082

    Metrics: via otelcol-contrib → grpc://<signoz-ip>:4317

These will show up in the SigNoz Metrics dashboard and under the Hosts tab.
❓ Want to monitor container metrics too?

If you want container-level metrics (CPU/memory per container), then add the docker_stats scraper like this:

  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu:
      memory:
      disk:
      filesystem:
      docker_stats:  # Add this

You must run the agent with access to Docker:

docker run \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /:/hostfs:ro \
  otel/opentelemetry-collector-contrib \
  --config /etc/otelcol-contrib/config.yaml

✅ Summary
Component	Purpose	How
logspout-signoz	Collect Docker container logs	Sends to http://<signoz-ip>:8082
otelcol-contrib	Collect host & container metrics	Sends to grpc://<signoz-ip>:4317
otel-collector-config.yaml (SigNoz server)	Handles log, metrics, trace ingestion	Already configured
Let me know if you want a full docker run example for the Otel agent as a container.

----------------------------------------------------------------------------------------------------
while using opentelementry agent for Logs and Metrics
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4320       ## changed port from 4317
      http:
        endpoint: 0.0.0.0:4318

  hostmetrics:
    collection_interval: 10s
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
      - type: move
        from: attributes.log
        to: body

processors:
  batch:
    send_batch_size: 1000
    timeout: 10s

  resourcedetection:
    detectors: [ec2, system]
    timeout: 2s
    system:
      hostname_sources: [os]

extensions:
#  health_check: {}
#  zpages: {}

exporters:
  otlp:
    endpoint: "52.5.140.96:4317"  # Replace with actual SigNoz OTLP IP if needed
    tls:
      insecure: true

  debug:
    verbosity: normal

service:
  telemetry:
    metrics:
      address: 0.0.0.0:8888

  extensions: []

  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]

    metrics/internal:
      receivers: [otlp, prometheus, hostmetrics]
      processors: [resourcedetection, batch]
      exporters: [otlp]

    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]

    logs:
      receivers: [otlp, filelog/containers]
      processors: [batch]
      exporters: [otlp]
```

<img width="1913" height="401" alt="image" src="https://github.com/user-attachments/assets/6203779b-19ca-4b0e-a92f-81af7d0417e9" />

Checked user

<img width="665" height="294" alt="image" src="https://github.com/user-attachments/assets/d2306797-76ce-4aae-b84f-d1a89810011f" />
so for metrics
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4326
      http:
        endpoint: 0.0.0.0:4327
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

processors:
  batch:
    send_batch_size: 1000
    timeout: 10s
  resourcedetection:
    detectors: [system, ec2]
    override: true

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
      receivers: [otlp, hostmetrics]
      processors: [resourcedetection, batch]
      exporters: [otlp]

```


<img width="1909" height="388" alt="image" src="https://github.com/user-attachments/assets/5c775156-be78-4107-8f47-b868c66b4f73" />

------------------------------------------------------------------------
1..logspout-signoz
```
docker run -d \
    --volume=/var/run/docker.sock:/var/run/docker.sock \
    -e 'SIGNOZ_LOG_ENDPOINT=http://52.5.140.96:8082' \
    -e 'ENV=prod' \
    pavanputhra/logspout-signoz \
    signoz://52.5.140.96:8082
```


<img width="272" height="264" alt="image" src="https://github.com/user-attachments/assets/009eca54-017d-44c2-ad9c-0b1a8eccfc71" />










