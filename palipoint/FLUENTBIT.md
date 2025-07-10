```
[SERVICE]
    Flush        1
    Daemon       Off
    Log_Level    info
    Parsers_File /etc/fluent-bit/parsers.conf

[INPUT]
    Name        tail
    Path        /var/log/syslog
    Parser      syslog
    Tag         syslog

[INPUT]
    Name        tail
    Path        /var/lib/docker/containers/*/*.log
    Parser      docker
    multiline.parser  docker, cri
    Tag         applog
    refresh_interval  5
    read_from_head    true
    skip_long_lines   on

[FILTER]
    name    modify
    match   *
    rename  log message

[OUTPUT]
    Name        opentelemetry
    Match       *
    Host        52.5.140.96
    Port        4318
    logs_uri              /v1/logs
    log_response_payload  false

```
