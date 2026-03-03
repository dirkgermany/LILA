## Asynchronous Alerting Architecture

To maintain high throughput (> 2,500 EPS), LILAM strictly decouples event analysis from notification dispatch. This prevents external latencies (e.g., SMTP handshakes) from impacting the core processing loop.

* **Responsiveness (RAM-First):** LILAM prioritizes immediate alerting over persistence. Alerts are triggered directly from the RAM-resident Rules Engine via [DBMS_ALERT].
* **High-Throughput Buffering:** To maintain > 2,500 EPS, event persistence is decoupled and buffered. Data is flushed to the `MONITOR_TABLES` asynchronously with a controlled delay (up to 1.8s), ensuring disk I/O never bottlenecks the real-time analysis.

### Alert Handshake Workflow
```mermaid
sequenceDiagram
    autonumber
    participant App as Application
    participant Srv as LILAM Server (RAM)
    participant Cons as Alert Consumer
    participant DB as MONITOR_TABLES (SSD)
    participant Mail as Mail Service

    Note over App, Srv: Real-Time Path (< 1ms)
    App->>Srv: trace_start / trace_stop
    Srv->>Srv: Rules Engine Check (RAM)
    
    alt Threshold Breached
        Note right of Srv: Instant Alerting from RAM
        Srv-->>Cons: Signal Breach (DBMS_ALERT)
    end

    Note over Srv, DB: Buffered Persistence Path (up to 1.8s delay)
    Srv->>DB: Async Bulk Insert (Scheduled Flush)
    
    Note over Cons, Mail: Notification Path
    Cons->>Mail: Trigger Email Dispatch
```
