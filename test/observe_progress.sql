select distinct proc.id proc_id, proc.process_name process, proc.process_start, proc.proc_steps_done proc_steps_done, detail.mon_steps_done,
        proc.proc_steps_todo * 100 / proc.proc_steps_done percent_of_work,
        round((TO_NUMBER(TO_CHAR(proc.process_start, 'SSSSS.FF3'), '99999.999', 'NLS_NUMERIC_CHARACTERS = ''. ''') - 
         TO_NUMBER(TO_CHAR(proc.last_update, 'SSSSS.FF3'), '99999.999', 'NLS_NUMERIC_CHARACTERS = ''. ''')) /-60, 2) min_work
from remote_log proc
join (
    select process_id, max(mon_steps_done) mon_steps_done
    from remote_log_detail
    group by process_id
) detail
    on detail.process_id = proc.id
    and detail.mon_steps_done is not null
order by proc.id
;
