# simpleOraLogger

## About
PL/SQL Package for simple logging of PL/SQL processes. Allows multiple and parallel logging out of the same session.

Even though debug information can be written, simpleOraLogger is primarily intended for monitoring (automated) PL/SQL processes (hereinafter referred to as the processes).
For easy daily monitoring log informations are written into two tables: one to see the status of your processes, one to see more details, e.g. something went wrong.
Your processes can be identified by their names.

## Simple means:
* Copy the package code to your database schema
* Call the logging procedures/functions out of your PL/SQL code
* Check log entries in the log tables

## Logging
simpleOraLogger monitors this informations about your processes:
* Process name
* Process ID
* Begin and Start
* Steps todo and steps done
* Any info
* (Last) status
