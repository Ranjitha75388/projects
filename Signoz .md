## What is SigNoz?

- SigNoz is an open-source observability tool that helps to monitor:

  -  Logs

  - Metrics (e.g., CPU, memory)

  - Traces (e.g., request flow in microservices)

- It’s an alternative to tools like DataDog, New Relic.
 
- SigNoz collects data using **OpenTelemetry (OTel**) and stores it in **ClickHouse**, a high-performance columnar database. We interact with it via a modern UI that offers dashboards, queries, and alerting.

- SigNoz in two ways:

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
```
# 1. Add the Fluent Bit GPG key
curl https://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

# 2. Add the official Fluent Bit repository to APT sources
echo "deb https://packages.fluentbit.io/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/fluentbit.list

# 3. Update package index
sudo apt-get update

# 4. Install Fluent Bit
sudo apt-get install -y fluent-bit
```
#### 2.Version check:
```
fluent-bit --version
```
#### 3.Create config:
```
sudo nano /etc/fluent-bit/fluent-bit.conf
```
#### 4.Configure Fluent Bit to read Docker container logs
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
> Replace SIGNOZ-IP ip EC2 public-ip

#### 5.Run Fluent Bit:
```
sudo /opt/fluent-bit/bin/fluent-bit -c /etc/fluent-bit/fluent-bit.conf
```
![Screenshot from 2025-06-20 11-49-59](https://github.com/user-attachments/assets/4a555fd3-c32a-482a-bf28-3465e30d1d98)

#### 6.View Logs in Signoz
- click logs
- Use filters or search to find  logs (e.g., search for "message" or container_id tags).
  
![Screenshot from 2025-06-20 11-27-53](https://github.com/user-attachments/assets/27e7eda3-3c81-4fec-8487-35b9c56f8f08)
