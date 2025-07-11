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
