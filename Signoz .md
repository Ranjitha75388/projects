## What is SigNoz?

- SigNoz is an open-source observability tool that helps to monitor:

  -  Logs

  - Metrics

  - Traces 

- It’s an alternative to tools like DataDog, New Relic.
 
- SigNoz collects data using **OpenTelemetry (OTel**) and stores it in **ClickHouse**, a high-performance columnar database. We interact with it via a modern UI that offers dashboards, queries, and alerting.

- Use SigNoz in two ways:

  - Cloud	Hosted -By SigNoz team.
  -  Self-hosted - We can install on our server

## What is OpenTelemetry (OTel)?

- OpenTelemetry is a standard for collecting and exporting logs, metrics, and traces from applications.

   - Collector: A service that receives, processes, and forwards telemetry data.

  - Protocol: OTLP (OpenTelemetry Protocol), used for sending data.

  - SDKs: Language-specific tools you can add to your app to generate telemetry.
 
## Installing SigNoz (Self-Hosted on Ubuntu EC2)

1. Install Docker and Docker Compose
```
sudo apt update
sudo apt install -y docker.io docker-compose
```
2. Clone SigNoz Repo
```
git clone -b main https://github.com/SigNoz/signoz.git
cd signoz/deploy/docker
```
3. Start SigNoz
```
sudo docker-compose up -d
```
4. Access Web UI
```
Go to http://<YOUR-EC2-IP>:3301
```
Create a user when prompted.

![image](https://github.com/user-attachments/assets/5474c977-4aa6-4ce8-8ce0-eb78a38b3642)

## What is Fluent Bit?

Fluent Bit is a lightweight log collector. It can:

 - Read logs (from files, containers, etc.)

 - Parse/filter them

 - Send logs to tools like SigNoz

#### 1.Install Fluent Bit Manually (App/Frontend EC2)

1.Add the Fluent Bit repository: 
```
sudo wget -qO /etc/apt/keyrings/fluentbit.asc https://packages.fluentbit.io/fluentbit.key
echo "deb [signed-by=/etc/apt/keyrings/fluentbit.asc] https://packages.fluentbit.io/ubuntu/$(lsb_release -sc) $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/fluentbit.list
```
2. Update the package lists:
```
sudo apt update
```
3.Install Fluent Bit:
```
sudo apt install -y fluent-bit
```
4. Enable and start the Fluent Bit service: 
```
sudo systemctl enable fluent-bit
sudo systemctl start fluent-bit
```
5.Verify the installation:
```
/opt/fluent-bit/bin/fluent-bit --version
sudo service fluent-bit status
```
![image](https://github.com/user-attachments/assets/108af645-ef97-49c0-b82a-a21e9177d1ae)

#### 2.Create config:
```
sudo nano /etc/fluent-bit/fluent-bit.conf
```
#### 3.Configure Fluent Bit to read Docker container logs
```
[SERVICE]
    flush        1
    daemon       Off
    log_level    info
    parsers_file /etc/fluent-bit/parsers.conf

[INPUT]
    name              tail
    path              /var/lib/docker/containers/*/*.log
    parser            docker
    multiline.parser  docker, cri
    tag               kube.*
    refresh_interval  5
    read_from_head    true
    skip_long_lines   on

[FILTER]
    name    modify
    match   *
    rename  log message

[OUTPUT]
    name                  opentelemetry
    match                 *
    host                  <SIGNOZ-IP>
    port                  4318
    logs_uri              /v1/logs
    log_response_payload  false

```
> Replace SIGNOZ-IP with EC2 public-ip

- **[INPUT]**: Tell Fluent Bit to tail log files from Docker containers.

- **Parser docker**: It knows how to parse Docker JSON logs (those *-json.log files).

- **[OUTPUT]**: Send logs using the OpenTelemetry (OTLP) protocol to SigNoz, which listens on port 4318.

#### 4.Run Fluent Bit:
```
sudo /opt/fluent-bit/bin/fluent-bit -c /etc/fluent-bit/fluent-bit.conf
```
![Screenshot from 2025-06-20 11-49-59](https://github.com/user-attachments/assets/4a555fd3-c32a-482a-bf28-3465e30d1d98)

#### 5.View Logs in Signoz
 
- opene SigNoz → Logs tab → and saw container logs flowing in!

- We can:

   - Filter logs

   - Search by keyword

   -  Click on individual logs for metadata

![Screenshot from 2025-06-20 11-27-53](https://github.com/user-attachments/assets/27e7eda3-3c81-4fec-8487-35b9c56f8f08)

## What Are Metrics?

- Metrics are numeric measurements that describe a system's behavior over time.

- Examples:

   - CPU usage (%)

   - Memory used (MB)

   - HTTP request counts

   - Response durations (ms)

   - Error rates

## What Are Dashboards?

- Dashboards are visual panels (charts/graphs) built using metrics.

- Example:

   -  A graph showing CPU usage over time

   -  A pie chart of request statuses (200 vs 500)

   -  A table of most frequent API endpoints

## How to Send Metrics to SigNoz?

There are 2 ways to send metrics to SigNoz:
### 1. Using OpenTelemetry SDK (App Level Metrics)

Install OpenTelemetry SDK in your application.

Example (Python):
```
pip install opentelemetry-sdk opentelemetry-exporter-otlp
```
Then in your app:
```
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter
```
This allows you to send custom business metrics like:

- Number of user signups

- Payment failures

- Queue lengths

### 2. Using Node Exporter / Prometheus (System Metrics)

#### Step 1: Install Node Exporter
```
cd ~
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64
./node_exporter &
```
- To run it in background permanently:
```
nohup ./node_exporter > node_exporter.log 2>&1 &
```
- Node Exporter now runs at:
```
 http://localhost:9100/metrics
```
- Test:
```
curl http://localhost:9100/metrics
```
#### Step 2: Configure SigNoz Otel Collector to scrape it

- Edit the file:
```
cd ~/signoz/deploy/docker
nano otel-collector-config.yaml
```
- Find this section under receivers.prometheus.config.scrape_configs:
```
scrape_configs:
  - job_name: node-exporter
    static_configs:
      - targets: ['localhost:9100']    ## node_exporter is installed on the same EC2 instance
```
- If it's not there, add this block under receivers.prometheus.config.
> If node_exporter is on a different EC2 instance, then you must provide that instance's private or public IP:
```
targets: ['<EC2-IP>:9100']
```
#### Step 3: Restart the otel-collector service
```
sudo docker compose restart otel-collector
```
#### Step 4: View Metrics in SigNoz

- Go to SigNoz web UI → Dashboards

- Click "+ New Dashboard"

- Give it a name like “SigNoz EC2 Metrics” → Click Create

- Inside the new dashboard, click "Add Panel"

- Choose "Time Series" (or Number / Table)

- In the Query box, enter a metric name, e.g.:

   > node_cpu_seconds_total

- Apply filters like mode=idle or instance=localhost:9100 if needed.

- Click Run Query → can see data.

- Click Save Panel

- Repeat for metrics like:

  > node_memory_MemAvailable_bytes

  > node_filesystem_size_bytes

  > node_network_receive_bytes_total

![Screenshot from 2025-06-20 13-46-36](https://github.com/user-attachments/assets/52d3dbf1-a683-4299-9a2a-6e9c5ba337c5)


## How to Set Alerts in SigNoz 

#### Step 1: Go to the Alerts Section

 - SigNoz --> Alerts --> Create Alert

####  Step 2: Define the Alert
➤ Choose Metric or Logs/Traces

    Select "Metric Based Alert"

➤ Select a PromQL query
```
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```
This tracks CPU usage.
#### Step 3: Set the Alert Condition
Example:
If value is greater than 80 for 5 minutes

#### Step 4: Add Alert Details

- Alert Name: e.g., High CPU Usage

- Description: e.g., CPU usage > 80% for 5 mins

- Severity: Choose Warning, Critical, etc.

#### Step 5: Choose Notification Channel

- Click Notification Channels

- Choose where to send alerts: Email, Slack,Webhook , PagerDuty, etc.

 > If no channel is set yet, go to Settings > Alert Channels and add one.

#### Step 6: Save & Activate

 - Click Create Alert

 - The alert will now be monitored continuously.












