DECLARE
    v_sessionRemote1_id VARCHAR2(100);
    v_sessionRemote2_id VARCHAR2(100);
    v_sessionRemote3_id VARCHAR2(100);
    v_sessionLokal_id   VARCHAR2(100);
    v_remoteCloser_id   VARCHAR2(100);
    v_shutdownResponse  VARCHAR2(500);
    v_startTime         TIMESTAMP;
    v_endTime           TIMESTAMP;
BEGIN
    v_startTime := systimestamp;                                                                                                                                                                                                                                                                                                                                                            

    -- New remote sessions
    v_sessionRemote1_id := lila.server_new_session('{"process_name":"Remote Session","log_level":8,"steps_todo":3,"days_to_keep":3,"tabname_master":"remote_log"}');
    dbms_output.put_line('Session remote: ' || v_sessionRemote1_id);
    v_sessionRemote2_id := lila.server_new_session('{"process_name":"Remote Session","log_level":8,"steps_todo":3,"days_to_keep":3,"tabname_master":"remote_log"}');
    dbms_output.put_line('Session remote: ' || v_sessionRemote2_id);
    v_sessionRemote3_id := lila.server_new_session('{"process_name":"Remote Session","log_level":8,"steps_todo":3,"days_to_keep":3,"tabname_master":"remote_log"}');
    dbms_output.put_line('Session remote: ' || v_sessionRemote3_id);
    
    -- New local session
    v_sessionLokal_id := lila.new_session('Local Session', 8, 'local_log');
    dbms_output.put_line('Session lokal: ' || v_sessionLokal_id);
   
    -- Bulk send
    for i in 1..1000 loop
        lila.info(v_sessionLokal_id, 'Nachricht vom lokalen Client');
        lila.info(v_sessionRemote1_id, 'Nachricht von Client 1');
        lila.info(v_sessionRemote2_id, 'Nachricht von Client 2');
        lila.info(v_sessionRemote3_id, 'Nachricht von Client 3');
    end loop;
   
    lila.close_session(v_sessionRemote1_id);
    dbms_output.put_line('Remote session closed');
    lila.close_session(v_sessionRemote2_id);
    dbms_output.put_line('Remote session closed');
    lila.close_session(v_sessionRemote3_id);
    dbms_output.put_line('Remote session closed');
    lila.close_session(v_sessionLokal_id);
    dbms_output.put_line('Local session closed');

    -- Session dedicated to server shutdown
    v_remoteCloser_id := lila.server_new_session('{"process_name":"Remote Session","log_level":8,"steps_todo":3,"days_to_keep":3,"tabname_master":"remote_log"}');
    dbms_output.put_line('Session remote for later server shutdown: ' || v_remoteCloser_id);  
    lila.server_shutdown(v_remoteCloser_id, 'still not important', 'geheim');
    dbms_output.put_line('Any server closed');
        
    -- Shutdown another server
    v_remoteCloser_id := lila.server_new_session('{"process_name":"Remote Session","log_level":8,"steps_todo":3,"days_to_keep":3,"tabname_master":"remote_log"}');
    dbms_output.put_line('Session remote: ' || v_remoteCloser_id);    
    lila.server_shutdown(v_remoteCloser_id, 'still not important', 'geheim');
    dbms_output.put_line('Another server closed');
    

    v_endTime := SYSTIMESTAMP;
    
    -- Berechnung der Millisekunden (SSSSS.FF extrahiert Sekunden seit Mitternacht inkl. Bruchteile)
    v_diff_millis := (TO_NUMBER(TO_CHAR(v_endTime, 'SSSSS.FF3'), '99999.999', 'NLS_NUMERIC_CHARACTERS = ''. ''') - 
                      TO_NUMBER(TO_CHAR(v_startTime, 'SSSSS.FF3'), '99999.999', 'NLS_NUMERIC_CHARACTERS = ''. ''')) * 1000;

    dbms_output.put_line('---');
    dbms_output.put_line('Intervall-Dauer: ' || (v_endTime - v_startTime));
    dbms_output.put_line('Dauer in Millisekunden: ' || ROUND(v_diff_millis, 0) || ' ms');


END;
/
