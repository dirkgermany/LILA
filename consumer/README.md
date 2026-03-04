# LILAM Consumer
The scope of the LILAM framework ends with rule validation. After processing incoming signals and evaluating them against the active rule set, LILAM’s last action is to fire an alert. From this point on, decoupled consumers take over the responsibility for further notification and handling.

## Consumer Responsibilities
Consumers are responsible for routing alerts to a wide variety of destinations, ensuring that critical notifications are immediately visible to stakeholders or available for further downstream analysis. Integration targets include:

* **Email Recipients:** Immediate notification for operational teams.
* **REST Endpoints:** Integration with external observability stacks (e.g., Grafana dashboards, webhooks, Slack/Teams).
* **Downstream LILAM Processes:** Chaining alerts to trigger complex, multi-stage monitoring workflows.

## Activation via DBMS_ALERT
Consumers are activated by `DBMS_ALERT` signals, typically within an event loop. The Oracle `DBMS_ALERT` implementation ensures that waiting for signals consumes **zero CPU time** while idle. The loop is only required to process alerts sequentially as they arrive.

All necessary metadata is transmitted as a JSON payload during the alerting process.

```sql

-- Sample: Waiting for an alert (Email Consumer)
DBMS_ALERT.REGISTER(LILAM_CONSUMER.C_ALERT_MAIL_LOG);
DBMS_OUTPUT.PUT_LINE('LILAM Mail-Log Consumer started...');

LOOP
    COMMIT; -- Required to receive the next alert signal
    
    -- Wait for the specific signal (C_ALERT_MAIL_LOG)
    -- v_msg_payload contains the JSON metadata
    DBMS_ALERT.WAITONE(LILAM_CONSUMER.C_ALERT_MAIL_LOG, v_msg_payload, v_status, 60);
    
    IF v_status = 0 THEN
      -- Incoming ALERT detected - wake up and process!
      -- handle_alert(v_msg_payload);
    END IF;
END LOOP;

```

## JSON Alert Payload
The following metadata is transmitted to the consumer as a JSON object. Since LILAM supports dynamic table structures, the `reference` column explains how the payload maps to the database:

* **PROC** = Tables storing Process Data (e.g., `LILAM_PROC`)
* **MON**  = Tables storing Monitoring/Event Data (e.g., `LILAM_MON`)

| Property | Type | Reference | Description |
| :--- | :--- | :--- | :--- |
| `alert_id` | number | `LILAM_ALERTS.ID` | Unique identifier for the specific alert. |
| `process_id` | number | Process ID | Maps to `PROC.ID` and `MON.PROCESS_ID`. |
| `tab_name_process` | string | Table Name | The specific process table name (e.g., `LILAM_PROC`). |
| `tab_name_monitor` | string | Table Name | The specific monitoring table name (e.g., `LILAM_MON`). |
| `action_name` | string | `MON.ACTION` | The name of the process or the specific action. |
| `context_name` | string | `MON.CONTEXT` | Optional granular detail (e.g., a specific track segment). |
| `action_count` | number | `MON.ACTION_COUNT` | The specific occurrence ID of the triggered event. |
| `rule_set_name` | string | `LILAM_RULES.SET_NAME` | The name of the active rule set. |
| `rule_set_version` | number | `LILAM_RULES.VERSION` | The specific version of the applied rule set. |
| `rule_id` | string | `rules.id` | The unique ID of the triggered rule within the JSON set. |
| `alert_severity` | string | `rules.alert.severity` | Severity level defined in the rule. |
| `timestamp` | string | System | ISO 8601 timestamp (`YYYY-MM-DD"T"HH24:MI:SS.FF6`). |


## Missed Alerts
A very first impulse of Oracle professionals could be countering that it is not sure that every single alert will be processed because of alerts can be overwritten. Correct.
Alerting means waking up Consumers. The Consumers themselve know their interests; they can be specialized to actions, contextes, group names, rules and rule sets and so on.
Zusätzlich stehen aber die Daten zum Zeitpunkt der Alarmierung bereits in der Tabelle `LILAM_ALERTS`zur Verfügung. Das hat zwei Vorteile:
1. Kein Verlust von Informationen bei Alarmierung in schneller Folge
2. Verarbeitung von mehreren Alarmen, auch wenn nur ein DBMS_ALERT erfolgte
3. Verarbeitung von Alarmen bei Neustart des Consumers (sofern erwünscht)


## Table LILAM_ALERTS
